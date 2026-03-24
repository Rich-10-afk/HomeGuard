//
//  DevicesView.swift
//  HomeGuard
//
//  Created by Ryan Kibet on 24/03/2026.
//

import SwiftUI

struct DevicesView: View {
    
    @EnvironmentObject var deviceStore: DeviceStore
    @State private var searchText = ""
    
    var filteredDevices: [Device] {
        if searchText.isEmpty {
            return deviceStore.devices
        }
        return deviceStore.devices.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.type.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        ZStack {
            Color("BackgroundPrimary").ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                
                HStack {
                    Text("Devices")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    NavigationLink(destination: AddDeviceView()) {
                        Image(systemName: "plus")
                            .foregroundColor(Color("AccentGreen"))
                            .font(.system(size: 20, weight: .semibold))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 12)
                
                SearchBar(text: $searchText)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(filteredDevices) { device in
                            NavigationLink(destination: DeviceDetailsView(device: device)) {
                                DeviceRow(device: device)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color("TextSecondary"))
            TextField("Search devices...", text: $text)
                .foregroundColor(.white)
        }
        .padding(10)
        .background(Color("SurfaceColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

struct DeviceRow: View {
    let device: Device
    
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(device.isOnline ? Color("AccentGreen").opacity(0.15) : Color("TextSecondary").opacity(0.15))
                .frame(width: 36, height: 36)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(device.name)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white)
                Text(device.type)
                    .font(.system(size: 11))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 3) {
                Text("● \(device.status)")
                    .font(.system(size: 11))
                    .foregroundColor(device.isOnline ? Color("AccentGreen") : Color("TextSecondary"))
                Text(device.lastActive)
                    .font(.system(size: 10))
                    .foregroundColor(Color("TextSecondary"))
            }
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color("TextSecondary"))
                .font(.system(size: 12))
        }
        .padding(12)
        .background(Color("SurfaceColor"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderColor"), lineWidth: 1)
        )
    }
}

#Preview {
    DevicesView()
        .environmentObject(DeviceStore())
}
