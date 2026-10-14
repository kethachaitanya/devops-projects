package com.abhishek;

public class ChallengeQualityIssue {

    public String environmentMessage(String environment) {
        if (environment == null) {
            return "unknown";
        }
        if (environment.equals("prod")) {
            return "production";
        }
        if (environment.equals("stage")) {
            return "staging";
        }
        if (environment.equals("dev")) {
            return "development";
        }
        return "unknown";
    }
}
