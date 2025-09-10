//
//  Configurations.swift
//  ClaseIOS
//
//  Created by Omar Bermejo Osuna on 09/09/25.
//

import SwiftUI
import Combine

enum OrdenOpciones: String, CaseIterable, Codable, Identifiable {
    case titulo = "Título"
    case subtitulo = "Subtítulo"
    
    var id: String { self.rawValue }
}

enum Apariencia: String, CaseIterable, Identifiable, Codable {
    case automatic = "Automático"
    case light = "Claro"
    case dark = "Oscuro"
    
    var id: String { self.rawValue }
}


class ConfigStore: ObservableObject {
    @Published var orden: OrdenOpciones = .titulo
    @Published var soloFotos: Bool = false
    @Published var maxItems: Int = 5
    @Published var apariencia: Apariencia = .automatic
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        cargarPreferencias()
        
        // Guardar cada vez que cambien las propiedades
        $orden
            .sink { _ in self.guardarPreferencias() }
            .store(in: &cancellables)
        
        $soloFotos
            .sink { _ in self.guardarPreferencias() }
            .store(in: &cancellables)
        
        $maxItems
            .sink { _ in self.guardarPreferencias() }
            .store(in: &cancellables)
        $apariencia.sink { _ in self.guardarPreferencias() }.store(in: &cancellables)
        
    }
    
    private func guardarPreferencias() {
        let defaults = UserDefaults.standard
        defaults.set(orden.rawValue, forKey: "orden")
        defaults.set(soloFotos, forKey: "soloFotos")
        defaults.set(maxItems, forKey: "maxItems")
        defaults.set(apariencia.rawValue, forKey: "apariencia")
    }
    
    private func cargarPreferencias() {
        let defaults = UserDefaults.standard
        if let ordenRaw = defaults.string(forKey: "orden"),
           let ordenGuardado = OrdenOpciones(rawValue: ordenRaw) {
            self.orden = ordenGuardado
        }
        self.soloFotos = defaults.bool(forKey: "soloFotos")
        self.maxItems = defaults.integer(forKey: "maxItems")
        if self.maxItems == 0 { self.maxItems = 5 } // valor por defecto
        if let aparienciaRaw = defaults.string(forKey: "apariencia"),
                  let aparienciaGuardada = Apariencia(rawValue: aparienciaRaw) {
                   self.apariencia = aparienciaGuardada
               }
    }
}

struct ConfigView: View {
    @ObservedObject var store: ConfigStore
    
    // Copias locales de las configuraciones
    @State private var orden: OrdenOpciones
    @State private var soloFotos: Bool
    @State private var maxItems: Int
    @State private var apariencia: Apariencia
    @Environment(\.dismiss) private var dismiss
    
    init(store: ConfigStore) {
        self.store = store
        // Inicializamos las copias con los valores actuales del store
        _orden = State(initialValue: store.orden)
        _soloFotos = State(initialValue: store.soloFotos)
        _maxItems = State(initialValue: store.maxItems)
        _apariencia = State(initialValue: store.apariencia)
    }
    
    var body: some View {
        Form {
            Section("Orden") {
                Picker("Ordenar por", selection: $orden) {
                    ForEach(OrdenOpciones.allCases) { opcion in
                        Text(opcion.rawValue).tag(opcion)
                    }
                }
                
                .pickerStyle(.segmented)
            }
            
            Section("Opciones") {
                Toggle("Solo fotos", isOn: $soloFotos)
                Stepper("Máx. ítems: \(maxItems)", value: $maxItems, in: 1...20)
                Picker("Apariencia", selection: $store.apariencia) {
                    ForEach(Apariencia.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)

            }
            HStack {
                    Button("Cancelar") {
                        dismiss()
                    }
                    .foregroundColor(.red)
              Spacer()
                    Button("Guardar") {
                        // Guardar cambios en el store real
                        store.orden = orden
                        store.soloFotos = soloFotos
                        store.maxItems = maxItems
                        dismiss()
                    }
                    .bold()
                }
            

                
        }
        .navigationTitle("Configuración")
        
    }
    
}



#Preview {
    ConfigView(store: ConfigStore())
}
