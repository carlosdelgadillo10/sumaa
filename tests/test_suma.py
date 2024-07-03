
import pytest
from fastapi.testclient import TestClient
from app.suma import app
import MEXICO
client = TestClient(app)

def test_sumar():
    response = client.post("/sumar", json={"num1": 10, "num2": 5})
    assert response.status_code == 200
    assert response.json() == 15

