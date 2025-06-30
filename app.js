let userAccount;
let contract;

// 🟢 Replace with your deployed contract address (from Remix "At Address")
const contractAddress = "0x93cF801Eae280D6D8Ee94654E4De81496f33BD2a";

async function connectMetaMask() {
  if (window.ethereum) {
    try {
      const accounts = await ethereum.request({ method: 'eth_requestAccounts' });
      userAccount = accounts[0];
      document.getElementById("wallet-status").innerText = userAccount;

      const web3 = new Web3(window.ethereum);

      // 🟢 Create contract instance using ABI + deployed address
      contract = new web3.eth.Contract(contractABI, contractAddress);

      console.log("Connected to contract:", contractAddress);
    } catch (err) {
      console.error("Connection failed", err);
      alert("Failed to connect MetaMask.");
    }
  } else {
    alert("Please install MetaMask.");
  }
}

async function releaseFunds() {
  if (!contract || !userAccount) {
    alert("Please connect MetaMask first.");
    return;
  }

  try {
    await contract.methods.releaseFunds().send({ from: userAccount });
    alert("✅ Funds successfully released to the seller!");
  } catch (err) {
    console.error("❌ Error calling releaseFunds():", err);
    alert("❌ Failed to release funds. Are you the buyer?");
  }
}
