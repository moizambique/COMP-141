/*
Shabbir Murtaza,
Mohammed Saleh,
Moiz Bukhari
*/

#include <iostream>
#include <regex>
using namespace std;
#include <string>

bool isNumber(const string &str)
{
    return regex_match(str, regex("^[0-9]+$"));
}

/*
check if a given string is a valid variable
(starting with a letter or underscore, then letter digit or underscore)
*/
bool isVariable(const string &str)
{
    return regex_match(str, regex("^(_|[a-zA-Z])([a-zA-Z0-9_])*$"));
}

bool isOperator(const string &str)
{
    return str == "+" || str == "-" || str == "*" || str == "/";
}

bool isEqualSign(const string &str)
{
    return str == "=";
}

int evaluate(int lhs, const string &op, int rhs)
{
    if (op == "+")
        return lhs + rhs;
    else if (op == "-")
        return lhs - rhs;
    else if (op == "*")
        return lhs * rhs;
    else if (op == "/")
        return lhs / rhs;
    throw invalid_argument("Unknown operator");
}

/*used https://learn.microsoft.com/en-us/dotnet/api/system.
text.regularexpressions.regex.match?view=net-8.0
to reference what we ended up writing for this function*/
void solveEquation(const string &input)
{
    // Regular expressions to match arithmetic expressions in the form of a basic equation
    regex expr("(\\w+)\\s*(\\+|\\-|\\*|/)\\s*(\\w+)\\s*=\\s*(\\w+)");
    regex expr1("(\\w+)\\s*=\\s*(\\w+)\\s*(\\+|\\-|\\*|/)\\s*(\\w+)");
    smatch match;

    if (regex_match(input, match, expr) || regex_match(input, match, expr1))
    {
        string leftOperand = match[1];
        string op = match[2];
        string rightOperand = match[3];
        string result = match[4];

        // cout << isOperator(op) << endl;
        // If the operator is not valid then the equation is reversed and swap logic
        if (!isOperator(op))
        {
            rightOperand = match[4];
            op = match[3];
            result = match[2];

            char temp = op[0];
            switch (temp)
            {
            case '+':
                op = "-";
                break;
            case '-':
                op = "+";
                break;
            case '*':
                op = "/";
                break;
            case '/':
                op = "*";
                break;
            }
            // cout << leftOperand << " " << op << " " << rightOperand << " = " << result << endl;
        }
        // cout << leftOperand << endl;
        // cout << op << endl;
        // cout << rightOperand << endl;
        // cout << result << endl;

        // checks if operands and result are numbers or variables
        bool leftIsNumber = isNumber(leftOperand);
        bool rightIsNumber = isNumber(rightOperand);
        bool resultIsNumber = isNumber(result);

        // if theyre all numbers it checks if the equation is valid
        if (leftIsNumber && rightIsNumber && resultIsNumber)
        {
            int leftVal = stoi(leftOperand);
            int rightVal = stoi(rightOperand);
            int resultVal = stoi(result);

            int calculatedResult = evaluate(leftVal, op, rightVal);
            if (calculatedResult == resultVal)
            {
                cout << "Syntactically Valid\nTrue Statement\n";
            }
            else
            {
                cout << "Syntactically Valid\nInvalid Statement\n";
            }
        }
        // if result is a variable and operands are numbers then it gets the result of the variable
        else if (leftIsNumber && rightIsNumber && isVariable(result))
        {
            int leftVal = stoi(leftOperand);
            int rightVal = stoi(rightOperand);
            int calcResult = evaluate(leftVal, op, rightVal);
            cout << "Syntactically Valid\n"
                 << result << " is " << calcResult << "\n";
        }
        // if left operand and result are numbers then it calculates for the right operand variable
        else if (leftIsNumber && isVariable(rightOperand) && resultIsNumber)
        {
            int leftVal = stoi(leftOperand);
            int resultVal = stoi(result);
            int calcResult;

            if (op == "+")
                calcResult = resultVal - leftVal;
            else if (op == "-")
                calcResult = leftVal - resultVal;
            else if (op == "*")
                calcResult = resultVal / leftVal;
            else if (op == "/")
                calcResult = leftVal / resultVal;

            cout << "Syntactically Valid\n"
                 << rightOperand << " is " << calcResult << "\n";
        }
        // if right operand and result are numbers then it calculates for the left operand variable
        else if (isVariable(leftOperand) && rightIsNumber && resultIsNumber)
        {
            int rightVal = stoi(rightOperand);
            int resultVal = stoi(result);
            int calcResult;

            if (op == "+")
                calcResult = resultVal - rightVal;
            else if (op == "-")
                calcResult = resultVal + rightVal;
            else if (op == "*")
                calcResult = resultVal / rightVal;
            else if (op == "/")
                calcResult = resultVal * rightVal;

            cout << "Syntactically Valid\n"
                 << leftOperand << " is " << calcResult << "\n";
        }
        else
        {
            cout << "Syntactically Valid\nUnsolvable\n";
        }
    }
    else
    {
        cout << "Syntax Error: Expected an equal sign\n";
    }
}

int main()
{
    string input;
    cout << "Enter a Statement: ";
    // takes user input as a string
    getline(cin, input);
    solveEquation(input);
    return 0;
}