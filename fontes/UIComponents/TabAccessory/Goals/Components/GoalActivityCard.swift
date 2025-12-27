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
                Text("Activity")
                    .font(.title3)
                    .fontWeight(.bold)
                
                Spacer()
                
                if !isEditing {
                    Button("CHANGE GOAL") {
                        withAnimation {
                            isEditing = true
                        }
                    }
                    .font(.system(size: 12, weight: .bold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Capsule())
                    .foregroundColor(.pink)
                } else {
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
            
            // Activity Card
            HStack(spacing: 0) {
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
                    .padding(.vertical, 22)
                    .frame(maxWidth: .infinity)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    
                } else {
                    // VIEW MODE: Stats + Ring
                    HStack(spacing: 0) {
                        // Left: Stats
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Readings")
                                .font(.headline)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("\(currentProgressArticles)")
                                    .foregroundColor(.pink)
                                Text("/")
                                    .foregroundColor(.pink)
                                Text("\(dailyGoalArticles)")
                                    .foregroundColor(.pink.opacity(0.7))
                            }
                            .font(.system(size: 38, weight: .bold, design: .rounded))
                            .contentTransition(.numericText(value: Double(dailyGoalArticles)))
                            
                            Text("ARTICLES")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        // Right: Ring
                        // Right: Flame
                        ZStack {
                            Image("ember")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                            
                            Image("fire_big")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 80, height: 80)
                                .offset(y: 10)
                        }
                        .frame(width: 100, height: 100)
                        .padding(.trailing, 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: progressPercentage)
                    }
                    .padding(24)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                }
            }
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .padding(.horizontal)
            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: isEditing)
        }
    }
}
