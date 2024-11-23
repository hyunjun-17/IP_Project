from langchain.chains import RetrievalQA
from langchain_openai import ChatOpenAI
from langchain_pinecone import PineconeVectorStore
from langchain_openai import OpenAIEmbeddings
from langchain import hub

def get_llm(model='gpt-4o'):
    llm = ChatOpenAI()
    return llm

def get_retriever(index_name):
    embedding = OpenAIEmbeddings(model='text-embedding-3-large')
    database = PineconeVectorStore.from_existing_index(embedding=embedding, index_name=index_name)
    retriever = database.as_retriever(search_kwargs={'k': 4})
    return retriever

def get_qa_chain(retriever):
    llm = get_llm()
    qa_chain = RetrievalQA.from_chain_type(
        llm,
        retriever=retriever,
        chain_type="stuff",
    )
    return qa_chain

def generate_ai_message(qa_chain, query):
    ai_message = qa_chain.invoke({"query": query})
    if ai_message and 'result' in ai_message:
        return ai_message['result']
    else:
        return ["검색 결과가 없습니다."]

def get_interview_questions(company_name, job_position):
    retriever = get_retriever('project')
    qa_chain = get_qa_chain(retriever)

    query = f"""{company_name}의 {job_position} 직무 면접에서 물어볼 수 있는 직무 관련 질문 3개를 작성해주세요. 설명이나 부가적인 문구 없이 질문만 작성해주세요.
    또한 면접 질문을 기반으로 직무 관련 질문을 생성할 때는 Question(Q)을 참고하여 직무 관련 질문을 생성해주세요. 질문은 넘버링(1., 2., 3.), Q 등 없이 질문만 간결히 작성해주세요."""

    return generate_ai_message(qa_chain, query)

def get_personality_questions(user_introduction):
    retriever = get_retriever('personal')
    qa_chain = get_qa_chain(retriever)

    query = (f"다음 자기소개서 내용을 바탕으로 물어볼 수 있는 인성 면접 질문 3개를 작성해주세요. 설명이나 부가적인 문구 없이 질문만 작성해주세요."
             f" 질문은 넘버링(1., 2., 3.), Q 등 없이 질문만 간결히 작성해주세요: {user_introduction}")

    return generate_ai_message(qa_chain, query)

def get_answer_feedback(question, answer, job_position=None, ipro_type=None):
    llm = get_llm()

    if ipro_type == 'position':
        prompt = f"""다음은 {job_position} 직무 면접 질문과 답변입니다:

질문: {question}
답변: {answer}

이 답변에 대한 전문적인 피드백을 제공해주세요. 다음 사항을 엄격하게 준수하세요.:
1. 직무 전문성, 구체성, 보완이 필요한 부분만 평가합니다.
2. **잘못된 정보가 있는 경우에만 수정을 제안하며, 없는 경우 이 섹션을 생략합니다.** 
3. 답변이 20자 이하일 경우 [장점] 섹션을 절대로 생성하지 마세요.
4. 장점과 개선점은 2개만 나열하세요. 장점이 없을 경우에는 [장점] 섹션 자체를 출력하지 마세요. 
5. 답변을 반드시 300자 이내로 작성하고, 각 섹션을 반드시 문단으로 구분하세요.

출력 형식:
[장점]
● 만약 답변이 대충 작성되었거나 장점이 없을 경우, 이 섹션을 **절대로 출력하지 마세요**.
● 답변이 전문성이나 성의가 없는 경우 장점을 **결코** 생성하지 마세요.

[개선점]
● 답변이 반말로 작성된 경우, "반말 사용은 피해야 합니다."라고 언급하세요.
● 보완이 필요한 부분들을 2개만  간단히 나열하세요.

[구체적인 제안]
● 회사의 인재상과 관련짓는 등 개선을 위한 실질적인 조언을 제공하세요.
● 올바른 답변으로 예시를 들어 수정해주세요

"""

    else:
        prompt = f"""다음은 인성 면접 질문과 답변입니다:

질문: {question}
답변: {answer}

이 답변에 대한 전문적인 피드백을 제공해주세요. 다음 사항을 엄격하게 준수하세요.:
1. 직무 전문성, 구체성, 보완이 필요한 부분만 평가합니다.
2. **잘못된 정보가 있는 경우에만 수정을 제안하며, 없는 경우 이 섹션을 생략합니다.** 
3. 답변이 20자 이하일 경우 장점 섹션을 절대로 생성하지 마세요.
4. 장점과 개선점은 2개만 간단히 나열하세요. 장점이 없을 경우에는 [장점] 섹션 자체를 출력하지 마세요. 
5. 답변을 반드시 300자 이내로 작성하고, 각 섹션을 반드시 문단으로 구분하세요.

출력 형식:
[장점]
● 만약 답변이 대충 작성되었거나 장점이 없을 경우, 이 섹션을 **절대로 출력하지 마세요**.
● 답변이 전문성이나 성의가 없는 경우 장점을 **결코** 생성하지 마세요.

[개선점]
● 답변이 반말로 작성된 경우, "반말 사용은 피해야 합니다."라고 언급하세요.
● 보완이 필요한 부분들을 2개만 간단히 나열하세요.

[구체적인 제안]
● 개선을 위한 실질적인 조언을 제공하세요.
● 올바른 답변으로 예시를 들어 수정해주세요

"""

    response = llm.invoke(prompt)

    return response.content

