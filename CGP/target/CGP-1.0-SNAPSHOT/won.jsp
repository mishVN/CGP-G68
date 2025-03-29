<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Premium Lucky Wheel</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            flex-direction: column;
            background: linear-gradient(to right, #ff9a9e, #fad0c4);
            font-family: 'Poppins', sans-serif;
            color: #333;
            text-align: center;
        }
        .container {
            position: relative;
        }
        .wheel {
            width: 350px;
            height: 350px;
            border-radius: 50%;
            border: 8px solid #fff;
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.2);
        }
        .pointer {
            position: absolute;
            top: -20px;
            left: 50%;
            transform: translateX(-50%);
            width: 40px;
            height: 60px;
            background-color: gold;
            clip-path: polygon(50% 0%, 100% 100%, 0% 100%);
            z-index: 10;
        }
        .popup {
            display: none;
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.3);
            font-size: 22px;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <audio id="spinSound" src="/magical-spinning-60410.mp3"></audio>

    <h1>Try Your Luck!</h1>
    <div class="container">
        <div class="pointer"></div>
        <canvas id="wheel" class="wheel"></canvas>
    </div>
    <div id="popup" class="popup"></div>
    <script>
        const canvas = document.getElementById("wheel");
        const ctx = canvas.getContext("2d");
        const size = 350;
        canvas.width = size;
        canvas.height = size;
        
        const segments = [
    "Gold Prize", "Silver Prize", "RS.500 Cash Bonus", "Gift Card", 
    "50% Discount", "Try Again", "Free Spin", "Big Win", "Small Win", 
    "Mystery Prize", "Extra Chance", "Lucky Draw"
];

const colors = [
    "#FFD700", "#C0C0C0", "#FF4500", "#4CAF50", "#1E90FF", "#8B0000",
    "#FF69B4", "#800080", "#008080", "#FF8C00", "#4682B4", "#32CD32"
];

        let angle = 0;
        let spinning = false;
        let popup = document.getElementById("popup");

        function drawWheel() {
    const segmentAngle = (2 * Math.PI) / segments.length;
    for (let i = 0; i < segments.length; i++) {
        ctx.beginPath();
        ctx.moveTo(size / 2, size / 2);
        ctx.arc(size / 2, size / 2, size / 2, i * segmentAngle, (i + 1) * segmentAngle);
        ctx.fillStyle = colors[i];
        ctx.fill();
        ctx.stroke();
        ctx.save();
        ctx.translate(size / 2, size / 2);
        ctx.rotate(i * segmentAngle + segmentAngle / 2);
        ctx.fillStyle = "white";
        ctx.font = "bold 14px Arial"; // Adjust font size for better fit
        ctx.fillText(segments[i], 50, 10);
        ctx.restore();
    }
}


function spinWheel() {
    if (spinning) return;
    spinning = true;
    
    let spinSound = document.getElementById("spinSound");
    spinSound.currentTime = 0; // Reset sound if played before
    spinSound.play(); // Play the spinning sound

    let spinAngle = Math.random() * 360 + 1800;
    let duration = 6000; 
    let start = null;

    function animateSpin(timestamp) {
        if (!start) start = timestamp;
        let progress = timestamp - start;
        let ease = Math.pow(progress / duration - 1, 3) + 1;
        angle = ease * spinAngle;

        ctx.clearRect(0, 0, size, size);
        ctx.save();
        ctx.translate(size / 2, size / 2);
        ctx.rotate(angle * Math.PI / 180);
        ctx.translate(-size / 2, -size / 2);
        drawWheel();
        ctx.restore();

        if (progress < duration) {
            requestAnimationFrame(animateSpin);
        } else {
            spinSound.pause(); // Stop the sound when spinning stops
            determinePrize(angle);
        }
    }
    requestAnimationFrame(animateSpin);
}


        function determinePrize(finalAngle) {
    let segmentAngle = 360 / segments.length;
    let winningIndex = Math.floor((360 - (finalAngle % 360)) / segmentAngle) % segments.length;
    popup.textContent = "Congratulations! You won: " + segments[winningIndex] + "!";
    popup.style.display = "block";
    setTimeout(() => popup.style.display = "none", 4000);
}


        drawWheel();
        window.onload = spinWheel; // Auto-spin on page load
    </script>
</body>
</html>