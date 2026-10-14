package com.abhishek;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;

@SpringBootTest
class StartApplicationTest {

    @Test
    void challenge01BuildMustFailUntilYouFixThisAssertion() {
        assertEquals("pipeline should pass", "pipeline should fail first");
    }
}
