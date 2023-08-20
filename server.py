from fastapi import FastAPI
from sentence_transformers import SentenceTransformer

model = SentenceTransformer("pkshatech/simcse-ja-bert-base-clcmlp")
app = FastAPI()

@app.get("/embedding")
def create_embedding(sentence: str):
    embeddings = model.encode(sentence)
    print(embeddings)
    return {
        "sentence": sentence,
        "embedding": embeddings.tolist()
    }

