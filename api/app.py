from fastapi import FastAPI

app = FastAPI(title="Secure Bank-Grade API")

@app.get("/healthz")
def healthz():
    return {"status": "ok"}

@app.get("/hello")
def hello(name: str = "world"):
    return {"message": f"hello, {name}"}
