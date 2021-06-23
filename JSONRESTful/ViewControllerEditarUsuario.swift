import UIKit

class ViewControllerEditarUsuario: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var users = [Users]()
    var userId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ruta = "http://localhost:3000/usuarios?"
        let url = ruta + "nombre=\(nombre)&clave=\(clave)"
        let crearURL = url.replacingOccurrences(of: " ", with:"%20")
        obtenerUsuario(ruta: crearURL) {
            for data in self.users{
                print("id:\(data.id),nombre:\(data.nombre),email:\(data.email)")

                self.txtNombre.text! = data.nombre
                self.txtContrasena.text! = data.clave
                self.txtEmail.text! = data.email
                self.userId = data.id
            }
        }
    }
    
    func obtenerUsuario(ruta:String, completed:@escaping () -> ()){
        let url = URL(string:ruta)
        URLSession.shared.dataTask(with: url!) {
            (data,response,error) in
            if error == nil{
                do{
                    self.users = try JSONDecoder().decode([Users].self,from:data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print(error)
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    @IBAction func btnActualizar(_ sender: Any) {
        let name = txtNombre.text!
        let contra = txtContrasena.text!
        let email = txtEmail.text!
        let datos = ["nombre":"\(name)","clave":"\(contra)","email":"\(email)"] as Dictionary<String, Any>
        let ruta = "http://localhost:3000/usuarios/\(userId)"
        metodoPUT(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
    }
    

    func metodoPUT(ruta:String, datos:[String:Any]) {
        let url : URL = URL(string:ruta)!
        var request = URLRequest(url:url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        let params = datos
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        }catch{
            //
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request,completionHandler: {
            (data,response,error) in
            if(data != nil){
                do{
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print(dict);
                }catch{
                    //
                }
            }
        })
        task.resume()
    }    
}
