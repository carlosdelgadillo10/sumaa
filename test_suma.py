# /tests/test_suma.py
import pytest
from fastapi.testclient import TestClient
from app.suma import app

client = TestClient(app)

def test_sumar():
    response = client.post("/sumar", json={"num1": 10, "num2": 5})
    assert response.status_code == 200
    assert response.json() == 15

