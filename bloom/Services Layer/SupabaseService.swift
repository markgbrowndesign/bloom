//
//  SupabaseService.swift
//  bloom
//
//  Created by Mark Brown on 11/05/2025.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
    supabaseURL: URL(string: "https://npcfmdljwtiivcavxqpe.supabase.co")!,
    supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5wY2ZtZGxqd3RpaXZjYXZ4cXBlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDY0NzY3NjksImV4cCI6MjA2MjA1Mjc2OX0.F-eP_5T9NX6Bhba1zl8MNNft7BR-71SPqGXd3k3wpJY"
)
