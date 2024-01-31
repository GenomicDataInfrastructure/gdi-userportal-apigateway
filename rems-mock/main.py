# SPDX-FileCopyrightText: 2024 PNED G.I.E.
#
# SPDX-License-Identifier: Apache-2.0

import uvicorn
from fastapi import FastAPI, Response

app = FastAPI()

@app.get("/api/my-applications")
def retrieve_catalogue():
    return Response(content=open("my-applications.json", "rb").read(), media_type="application/json")

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
