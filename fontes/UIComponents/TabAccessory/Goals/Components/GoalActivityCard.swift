//
//  GoalActivityCard.swift
//  fontes
//
//  Created by Mateus Costa on 26/12/2025.
//

import SwiftUI

struct GoalActivityCard: View {
    @Binding var isEditing: Bool
    @Binding var dailyGoalArticles: Int
    var currentProgressArticles: Int
    
    var progressPercentage: Double {
        return Double(currentProgressArticles) / Double(dailyGoalArticles)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Objetivos")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                if isEditing {
                    Button("DONE") {
                        withAnimation {
                            isEditing = false
                        }
                    }
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.pink)
                    .clipShape(Capsule())
                    .foregroundColor(.white)
                }
            }
            .padding(.horizontal)
            
            HStack {
                // Activity Card
                ZStack {
                    if isEditing {
                        // EDIT MODE: Stepper
                        HStack(spacing: 24) {
                            Button(action: {
                                if dailyGoalArticles > 1 {
                                    let generator = UIImpactFeedbackGenerator(style: .light)
                                    generator.impactOccurred()
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                        dailyGoalArticles -= 1
                                    }
                                }
                            }) {
                                Image(systemName: "minus")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 56, height: 56)
                                    .background(dailyGoalArticles > 1 ? Color.white : Color.clear)
                                    .foregroundColor(dailyGoalArticles > 1 ? .primary : Color(.tertiaryLabel))
                                    .clipShape(Circle())
                            }
                            .disabled(dailyGoalArticles <= 1)
                            .buttonStyle(ScaleButtonStyle())
                            
                            VStack(spacing: 4) {
                                Text("\(dailyGoalArticles)")
                                    .font(.system(size: 48, weight: .bold, design: .rounded))
                                    .contentTransition(.numericText(value: Double(dailyGoalArticles)))
                                
                                Text("TARGET")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.secondary)
                            }
                            .frame(minWidth: 80)
                            
                            Button(action: {
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                generator.impactOccurred()
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    dailyGoalArticles += 1
                                }
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 24, weight: .bold))
                                    .frame(width: 56, height: 56)
                                    .background(Color.white)
                                    .foregroundColor(.primary)
                                    .clipShape(Circle())
                            }
                            .buttonStyle(ScaleButtonStyle())
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .transition(.opacity.combined(with: .scale(scale: 0.95)))
                        
                    } else {
                        // The Container
                        HStack(spacing: 0) {
                            // Left: Stats
                            VStack(alignment: .leading, spacing: 2) {
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(currentProgressArticles)")
                                        .foregroundColor(.pink)
                                    Text("/")
                                        .foregroundColor(.pink)
                                    Text("\(dailyGoalArticles)")
                                        .foregroundColor(.pink.opacity(0.7))
                                }
                                .font(.system(size: 39, weight: .bold, design: .rounded))
                                .contentTransition(.numericText(value: Double(dailyGoalArticles)))
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.vertical, 24)
                        .background {
                            ZStack(alignment: .bottomTrailing) {
                                Color(.secondarySystemBackground)
                                
                                Image("fire_big")
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 280)
                                    .offset(x: 38, y: -36)
                                    .opacity(0.14)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
                        .overlay(alignment: .bottomTrailing) {
                            Button {
                                withAnimation {
                                    isEditing = true
                                }
                            } label: {
                                Image(systemName: "pencil")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.secondary)
                                    .frame(width: 28, height: 28)
                                    .background(Color(.tertiarySystemFill))
                                    .clipShape(Circle())
                            }
                            .padding(12)
                        }
                        .overlay(alignment: .trailing) {
                            Image("fire_big")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 180)
                                .fixedSize()
                                .offset(x: -14)
                        }
                    }
                }
                .padding(.horizontal)
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isEditing)
            }
        }
    }
}
