import uvicorn
from fastapi import FastAPI, Response
from fastapi.middleware.cors import CORSMiddleware
import os

app = FastAPI()

@app.post("/v2.0.0/individuals")
def retrieve_catalogue():
    return Response(content=open("individuals.json", "rb").read(), media_type="application/json")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
