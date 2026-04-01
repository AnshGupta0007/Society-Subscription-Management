// Get API URL from environment or use localhost for development
const API_BASE = process.env.NEXT_PUBLIC_API_URL || "http://localhost:5000";
const API = `${API_BASE}/api`;

export default API;
export { API_BASE };
