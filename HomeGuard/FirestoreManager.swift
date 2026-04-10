import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirestoreManager{
    
    private let db = Firestore.firestore()
    
    
    func fetchDevices(completion: @escaping ([Device]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("devices")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching devices: \(error)")
                    return
                }
                
                let devices = snapshot?.documents.compactMap { doc -> Device? in
                    let data = doc.data()
                    return Device(
                        id: data["id"] as? Int ?? 0,
                        name: data["name"] as? String ?? "",
                        type: data["type"] as? String ?? "",
                        status: data["status"] as? String ?? "",
                        lastActive: data["lastActive"] as? String ?? "",
                        isOnline: data["isOnline"] as? Bool ?? false
                    )
                } ?? []
                
                completion(devices)
            }
    }
    
    func addDevice(_ device: Device) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("devices")
            .document("\(device.id)")
            .setData([
                "id": device.id,
                "name": device.name,
                "type": device.type,
                "status": device.status,
                "lastActive": device.lastActive,
                "isOnline": device.isOnline
            ])
    }
    
    func updateDevice(_ device: Device) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("devices")
            .document("\(device.id)")
            .updateData([
                "status": device.status,
                "lastActive": device.lastActive,
                "isOnline": device.isOnline
            ])
    }
    
    func removeDevice(_ device: Device) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("devices")
            .document("\(device.id)")
            .delete()
    }
    
    
    func fetchLogs(completion: @escaping ([SecurityLog]) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users")
            .document(userId)
            .collection("logs")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching logs: \(error)")
                    return
                }
                
                let logs = snapshot?.documents.compactMap { doc -> SecurityLog? in
                    let data = doc.data()
                    let typeString = data["type"] as? String ?? "access"
                    let type: SecurityLog.LogType = {
                        switch typeString {
                        case "warning": return .warning
                        case "danger": return .danger
                        default: return .access
                        }
                    }()
                    
                    return SecurityLog(
                        title: data["title"] as? String ?? "",
                        subtitle: data["subtitle"] as? String ?? "",
                        time: data["time"] as? String ?? "",
                        type: type
                    )
                } ?? []
                
                completion(logs)
            }
    }
    
    func addLog(_ log: SecurityLog) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let typeString: String = {
            switch log.type {
            case .access: return "access"
            case .warning: return "warning"
            case .danger: return "danger"
            }
        }()
        
        db.collection("users")
            .document(userId)
            .collection("logs")
            .addDocument(data: [
                "title": log.title,
                "subtitle": log.subtitle,
                "time": log.time,
                "type": typeString,
                "timestamp": FieldValue.serverTimestamp()
            ])
    }
}
