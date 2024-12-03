import SwiftUI

// Estrutura para o objetivo do usuário
struct UserGoal: Codable {
    var goal: String
    var customGoal: String?
}

// Estrutura para recompensas
struct Reward: Identifiable, Codable {
    var id = UUID()
    var name: String
    var pointsRequired: Int
}

// Função para obter o diretório de documentos
func getDocumentsDirectory() -> URL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

// ContentView - Tela inicial
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink("Desafios Personalizados", destination: SecondView())
                    .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
                NavigationLink("Registro de Atividades", destination: ThirdView())
                    .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
                NavigationLink("Planos de Treino", destination: FourthView())
                    .padding()
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
                NavigationLink("Metas e Recompensas", destination: FifthView())
                    .padding()
                                        .background(Color.purple)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                        .frame(maxWidth: .infinity)
            }
            .navigationTitle("MoveUp")
            .padding(.top)
        }
    }
}

// Segunda página - Desafios Personalizados
struct SecondView: View {
    @State private var selectedGoal = "Perda de peso"
    @State private var customInput = ""
    @State private var isSaved = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Escolha seu objetivo").font(.largeTitle)
            Picker("Objetivo", selection: $selectedGoal) {
                Text("Perda de peso").tag("Perda de peso")
                Text("Ganho muscular").tag("Ganho muscular")
                Text("Aumento da resistência").tag("Aumento da resistência")
                Text("Personalizado").tag("Personalizado")
            }
            .pickerStyle(MenuPickerStyle())
            .padding()

            if selectedGoal == "Personalizado" {
                TextField("Digite seu objetivo", text: $customInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            Button("Confirmar") {
                saveUserGoal()
            }
            .alert(isPresented: $isSaved) {
                Alert(title: Text("Sucesso"), message: Text("Objetivo salvo com sucesso!"), dismissButton: .default(Text("OK")))
            }
            .padding()
        }
        .navigationTitle("Desafios Personalizados")
        .onAppear(perform: loadUserGoal)
    }

    func saveUserGoal() {
        let userGoal = UserGoal(goal: selectedGoal, customGoal: customInput)
        if let data = try? JSONEncoder().encode(userGoal) {
            let url = getDocumentsDirectory().appendingPathComponent("user_goal.json")
            try? data.write(to: url)
            isSaved = true
        }
    }

    func loadUserGoal() {
        let url = getDocumentsDirectory().appendingPathComponent("user_goal.json")
        if let data = try? Data(contentsOf: url),
           let userGoal = try? JSONDecoder().decode(UserGoal.self, from: data) {
            selectedGoal = userGoal.goal
            customInput = userGoal.customGoal ?? ""
        }
    }
}

// Terceira página - Registro de Atividades
struct ThirdView: View {
    @State private var activityInput = ""
    @State private var activities: [String] = []
    @State private var isLogged = false

    var body: some View {
        VStack {
            Text("Registro de Atividades").font(.largeTitle)
            TextField("Digite a atividade", text: $activityInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Registrar Atividade") {
                logActivity()
            }
            .alert(isPresented: $isLogged) {
                Alert(title: Text("Sucesso"), message: Text("Atividade registrada com sucesso!"), dismissButton: .default(Text("OK")))
            }
            .padding()

            List(activities, id: \.self) { activity in
                Text(activity)
            }
        }
        .onAppear(perform: loadActivities)
        .navigationTitle("Registro de Atividades")
    }

    func logActivity() {
        let newActivity = activityInput
        activities.append(newActivity)
        saveActivities()
        activityInput = ""
        isLogged = true
    }

    func saveActivities() {
        let url = getDocumentsDirectory().appendingPathComponent("activities.json")
        if let data = try? JSONEncoder().encode(activities) {
            try? data.write(to: url)
        }
    }

    func loadActivities() {
        let url = getDocumentsDirectory().appendingPathComponent("activities.json")
        if let data = try? Data(contentsOf: url),
           let loadedActivities = try? JSONDecoder().decode([String].self, from: data) {
            activities = loadedActivities
        }
    }
}

// Quarta página - Planos de Treino
struct FourthView: View {
    @State private var selectedPlan: String?

    var body: some View {
        VStack {
            Text("Planos de Treino Personalizados").font(.largeTitle)
            Text("Escolha seu nível de habilidade:").font(.headline)

            VStack(spacing: 15) {
                Button("Plano para Iniciantes") {
                    saveTrainingPlan(plan: "Plano para Iniciantes: 30 min de caminhada, 15 min de treino de força.")
                }
                Button("Plano Intermediário") {
                    saveTrainingPlan(plan: "Plano Intermediário: 45 min de corrida, 30 min de treino de força.")
                }
                Button("Plano Avançado") {
                    saveTrainingPlan(plan: "Plano Avançado: 60 min de corrida, 45 min de treino de força.")
                }
            }
            .padding()

            if let plan = selectedPlan {
                Text("Plano selecionado: \(plan)")
                    .font(.headline)
                    .padding()
            }
        }
        .onAppear(perform: loadTrainingPlan)
        .navigationTitle("Planos de Treino")
    }

    func saveTrainingPlan(plan: String) {
        selectedPlan = plan
        let url = getDocumentsDirectory().appendingPathComponent("training_plan.json")
        if let data = try? JSONEncoder().encode(plan) {
            try? data.write(to: url)
        }
    }

    func loadTrainingPlan() {
        let url = getDocumentsDirectory().appendingPathComponent("training_plan.json")
        if let data = try? Data(contentsOf: url),
           let plan = try? JSONDecoder().decode(String.self, from: data) {
            selectedPlan = plan
        }
    }
}

// Quinta página - Metas e Recompensas
struct FifthView: View {
    @State private var score = 0
    @State private var rewards = [
        Reward(name: "Badge de Iniciante", pointsRequired: 10),
        Reward(name: "Cupom de Desconto de 20%", pointsRequired: 20),
        Reward(name: "Equipamento de Treino", pointsRequired: 30)
    ]
    @State private var redeemMessage = ""
    @State private var redeemedRewards: [String] = []

    var body: some View {
        VStack {
            Text("Metas e Recompensas").font(.largeTitle)
            Text("Pontos: \(score)").font(.headline)

            List(rewards) { reward in
                Button(action: { redeemReward(reward) }) {
                    HStack {
                        Text(reward.name)
                        Spacer()
                        Text("\(reward.pointsRequired) Pontos").foregroundColor(.gray)
                    }
                }
                .disabled(reward.pointsRequired > score || redeemedRewards.contains(reward.name))
            }

            Text(redeemMessage).foregroundColor(.red)
        }
        .onAppear(perform: loadScore)
        .navigationTitle("Metas e Recompensas")
    }

    func redeemReward(_ reward: Reward) {
        if reward.pointsRequired <= score && !redeemedRewards.contains(reward.name) {
            score -= reward.pointsRequired
            redeemedRewards.append(reward.name)
            redeemMessage = "Recompensa resgatada: \(reward.name)!"
            saveRedeemedRewards()
            saveScore()
        } else {
            redeemMessage = "Você não tem pontos suficientes ou já resgatou esta recompensa."
        }
    }

    func loadScore() {
        let url = getDocumentsDirectory().appendingPathComponent("score.json")
        score = (try? JSONDecoder().decode(Int.self, from: Data(contentsOf: url))) ?? 0
        
        let rewardsUrl = getDocumentsDirectory().appendingPathComponent("redeemed_rewards.json")
        redeemedRewards = (try? JSONDecoder().decode([String].self, from: Data(contentsOf: rewardsUrl))) ?? []
    }

    func saveScore() {
        let url = getDocumentsDirectory().appendingPathComponent("score.json")
        if let data = try? JSONEncoder().encode(score) {
            try? data.write(to: url)
        }
    }

    func saveRedeemedRewards() {
        let url = getDocumentsDirectory().appendingPathComponent("redeemed_rewards.json")
        if let data = try? JSONEncoder().encode(redeemedRewards) {
            try? data.write(to: url)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
