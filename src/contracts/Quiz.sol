pragma solidity ^0.4.18;

contract Quiz {
    address private owner;
    uint256 private expires;

    string[6] public questions;
    bytes32[6] public answers;

    bool public claimed;

    function Quiz() public {
        owner = msg.sender;
        expires = now + 2 days;
        claimed = false;

        questions[0] = "What is the network ID number of the public ethereum blockchain?";
        answers[0] = 0xc89efdaa54c0f20c7adf612882df0950f5a951637e0307cdcb4c672f298b8bc6;
    }

    function numberOfQuestions() public constant returns (uint256) {
        return questions.length;
    }

    function updateQuestionAndAnswer(string question, bytes answer, uint index) public onlyOwner {
        questions[index] = question;
        answers[index] = keccak256(answer);
    }

    function checkAnswer(uint index, bytes answer) public constant returns(bool) {
        bytes32 hashedAnswer = keccak256(answer);
        return answers[index] == hashedAnswer;
    }

    function checkAllAnswers(bytes32[] myAnswers) public constant returns(bool) {
        for (uint8 i = 0; i < answers.length; i++) {
            bytes32 hashedAnswer = keccak256(myAnswers[i]);
            require(hashedAnswer == answers[i]);
        }
        return true;
    }

    function submitYourAnswers(bytes32[] myAnswers) public returns(bool) {
        require(claimed != true);

        for (uint8 i = 0; i < answers.length; i++) {
            bytes32 hashedAnswer = keccak256(myAnswers[i]);
            require(hashedAnswer == answers[i]);
        }

        claimed = true;
        msg.sender.transfer(this.balance);
        return claimed;
    }

    function () public payable {
    }

    function refund(address to) public onlyOwner {
        require(claimed != true);
        require(now > expires + 1 hours);
        
        to.transfer(this.balance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}