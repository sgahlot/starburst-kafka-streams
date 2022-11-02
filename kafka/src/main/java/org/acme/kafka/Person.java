package org.acme.kafka;

public class Person {
    public static enum Genre {
        M, F;

        static Genre random() {
            if (Math.random() > 0.5) {
                return F;
            }
            return M;
        }
    }

    public String name;
    public Genre genre;
    public int age;

    public Person() {
    }

    public Person(String name, Genre genre, int age) {
        this.name = name;
        this.genre = genre;
        this.age = age;
    }

    @Override
    public String toString() {
        return "Person [name=" + name + ", genre=" + genre + ", age=" + age + "]";
    }
}
