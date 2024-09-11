#include <iostream>
#include <regex>
using namespace std;
#include <string>

bool isNumber(const string& str) {
    return regex_match(str, regex("^[0-9]+$"));
}

bool isVariable(const string& str) {
    return regex_match(str, regex("^(_|[a-zA-Z])([a-zA-Z0-9_])*$"));
}

bool isOperator(const string& str) {
    return str == "+" || str == "-" || str == "*" || str == "/";
}

bool isEqualSign(const string& str) {
    return str == "=";
}

int evaluate(int lhs, const string& op, int rhs) {
    if (op == "+") return lhs + rhs;
    else if (op == "-") return lhs - rhs;
    else if (op == "*") return lhs * rhs;
    else if (op == "/") return lhs / rhs;
    throw invalid_argument("Unknown operator");
}

void solveEquation(const string& input) {
    regex expr("(\\w+)\\s*(\\+|\\-|\\*|/)\\s*(\\w+)\\s*=\\s*(\\w+)");
    smatch match;
    
    if (regex_match(input, match, expr)) {
        string leftOperand = match[1];
        string op = match[2];
        string rightOperand = match[3];
        string result = match[4];

        bool leftIsNumber = isNumber(leftOperand);
        bool rightIsNumber = isNumber(rightOperand);
        bool resultIsNumber = isNumber(result);

        if (leftIsNumber && rightIsNumber && resultIsNumber) {
            int leftVal = stoi(leftOperand);
            int rightVal = stoi(rightOperand);
            int resultVal = stoi(result);
            
            int calculatedResult = evaluate(leftVal, op, rightVal);
            if (calculatedResult == resultVal) {
                cout << "Syntactically Valid\nTrue Statement\n";
            } else {
                cout << "Syntactically Valid\nInvalid Statement\n";
            }
        } else if (leftIsNumber && rightIsNumber && isVariable(result)) {
            int leftVal = stoi(leftOperand);
            int rightVal = stoi(rightOperand);
            int calcResult = evaluate(leftVal, op, rightVal);
            cout << "Syntactically Valid\n" << result << " is " << calcResult << "\n";
        } else if (leftIsNumber && isVariable(rightOperand) && resultIsNumber) {
            int leftVal = stoi(leftOperand);
            int resultVal = stoi(result);
            int calcResult;

            if (op == "+") calcResult = resultVal - leftVal;
            else if (op == "-") calcResult = leftVal - resultVal;
            else if (op == "*") calcResult = resultVal / leftVal;
            else if (op == "/") calcResult = leftVal / resultVal;

            cout << "Syntactically Valid\n" << rightOperand << " is " << calcResult << "\n";
        } else if (isVariable(leftOperand) && rightIsNumber && resultIsNumber) {
            int rightVal = stoi(rightOperand);
            int resultVal = stoi(result);
            int calcResult;

            if (op == "+") calcResult = resultVal - rightVal;
            else if (op == "-") calcResult = resultVal + rightVal;
            else if (op == "*") calcResult = resultVal / rightVal;
            else if (op == "/") calcResult = resultVal * rightVal;

            cout << "Syntactically Valid\n" << leftOperand << " is " << calcResult << "\n";
        } else {
            cout << "Syntactically Valid\nUnsolvable\n";
        }
    } else {
        cout << "Syntax Error: Expected an equal sign\n";
    }
}

int main() {
    string input;
    cout << "Enter a Statement: ";
    getline(cin, input);

    solveEquation(input);

    return 0;
}