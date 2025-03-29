<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Flappy Bird Clone</title>
    <style>
        body {
            margin: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: skyblue;
        }
        canvas {
            border: 2px solid black;
            background: url('2.jpg') no-repeat center center/cover;
        }
        button {
            margin-top: 10px;
            padding: 12px 24px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            border-radius: 50px;
            color: white;
            text-transform: uppercase;
            transition: all 0.3s ease-in-out;
            position: relative;
            overflow: hidden;
        }
        #startButton {
            background: linear-gradient(45deg, #ff7b00, #ff1b6b);
            box-shadow: 0 0 10px #ff7b00, 0 0 40px #ff1b6b;
        }
        #retryButton, #prizeButton {
            background: linear-gradient(45deg, #00c3ff, #0072ff);
            box-shadow: 0 0 10px #00c3ff, 0 0 40px #0072ff;
            display: none;
        }
        button:hover {
            transform: scale(1.1);
            box-shadow: 0 0 20px rgba(255, 255, 255, 0.8), 0 0 50px rgba(255, 255, 255, 0.6);
        }
        .game-over {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            color: red;
            font-size: 50px;
            font-family: 'Arial', sans-serif;
            font-weight: bold;
            text-shadow: 0 0 20px rgba(255, 0, 0, 0.7), 0 0 30px rgba(255, 0, 0, 0.6);
            display: none;
        }
    </style>
</head>
<body>
    <canvas id="gameCanvas" width="400" height="500"></canvas>
    <button id="startButton">Start Game</button>
    <button id="retryButton">Retry</button>
    <button id="prizeButton" onclick="window.location.href='won.jsp'">Claim Your Prize</button>
    <div id="gameOverMessage" class="game-over">Game Over</div>
    <div id="prizeMessage" class="game-over" style="color: green; display: none;">You won a prize!</div>

    <script>
        const canvas = document.getElementById("gameCanvas");
        const ctx = canvas.getContext("2d");
        const startButton = document.getElementById("startButton");
        const retryButton = document.getElementById("retryButton");
        const prizeButton = document.getElementById("prizeButton");
        const gameOverMessage = document.getElementById("gameOverMessage");
        const prizeMessage = document.getElementById("prizeMessage");

        let bird, pipes, score, gameRunning, frames;
        let birdImg = new Image();
        birdImg.src = "o_bg-remover-gen_2t8Hsm2hkmX8JUCP7EUqKWilZ87.png";

        function initializeGame() {
            bird = { x: 50, y: 150, width:50, height: 50, velocity: 0, gravity: 0.4 };
            pipes = [];
            score = 0;
            gameRunning = true;
            frames = 0;
            retryButton.style.display = "none";
            prizeButton.style.display = "none";
            startButton.style.display = "none";
            gameOverMessage.style.display = "none";
            prizeMessage.style.display = "none";
            update();
        }

        function drawBird() {
            ctx.drawImage(birdImg, bird.x, bird.y, bird.width, bird.height);
        }

        function drawPipes() {
            ctx.fillStyle = "green";
            pipes.forEach(pipe => {
                ctx.fillRect(pipe.x, 0, pipe.width, pipe.top);
                ctx.fillRect(pipe.x, pipe.bottom, pipe.width, canvas.height - pipe.bottom);
            });
        }

        function update() {
            if (!gameRunning) return;
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            bird.velocity += bird.gravity;
            bird.y += bird.velocity;

            if (bird.y + bird.height > canvas.height) gameOver();

            pipes.forEach(pipe => {
                pipe.x -= 6; // Increased pipe speed

                if (pipe.x + pipe.width < 0) {
                    pipes.shift();
                    score++;
                }

                if (
                    bird.x < pipe.x + pipe.width &&
                    bird.x + bird.width > pipe.x &&
                    (bird.y < pipe.top || bird.y + bird.height > pipe.bottom)
                ) {
                    gameOver();
                }
            });

            if (frames % 80 === 0) { // Reduced interval for new pipes
                let pipeHeight = Math.floor(Math.random() * (canvas.height / 2)) + 50;
                pipes.push({
                    x: canvas.width,
                    width: 50,
                    top: pipeHeight,
                    bottom: pipeHeight + 180 // Reduced gap between pipes
                });
            }

            drawBird();
            drawPipes();
            ctx.fillStyle = "black";
            ctx.font = "20px Arial";
            ctx.fillText("Score: " + score, 10, 20);

            if (score >= 5) {
                winGame();
                return;
            }

            frames++;
            requestAnimationFrame(update);
        }

        function jump() {
            if (gameRunning) {
                bird.velocity = -7;
            }
        }

        function gameOver() {
            gameRunning = false;
            gameOverMessage.style.display = "block";
            retryButton.style.display = "block";
        }

        function winGame() {
            gameRunning = false;
            prizeMessage.style.display = "block";
            prizeButton.style.display = "block";
        }

        document.addEventListener("keydown", jump);
        startButton.addEventListener("click", initializeGame);
        retryButton.addEventListener("click", initializeGame);
    </script>
</body>
</html>