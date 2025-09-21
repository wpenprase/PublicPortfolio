import java.util.*;

public class CapitalQuizApp {
    private final String[][] stateCapitalPairs;
    private final Scanner scanner;


    //Constructor
    public CapitalQuizApp(String[][] stateCapitalPairs, Scanner scanner) {
        this.stateCapitalPairs = stateCapitalPairs;
        this.scanner = scanner;
    }

    public void runQuiz() {
        String[][] shuffled = shuffle2DArray(stateCapitalPairs);
        int correctCount = 0;

        for (int i = 0; i < shuffled.length; i++) {
            System.out.print("\nEnter the capital of " + shuffled[i][0] + " or type 'skip' to skip:\n\n");
            String input = scanner.nextLine().trim();

            if (input.equalsIgnoreCase("skip")) break;

            if (input.equalsIgnoreCase(shuffled[i][1])) {
                correctCount++;
                System.out.println("Correct! " + correctCount + " out of " + (i + 1));
            } else {
                System.out.println("Incorrect. " + correctCount + " out of " + (i + 1));
            }
        }

        System.out.println("\nQuiz complete! You answered " + correctCount + " out of " + shuffled.length + " correctly.");
    }

    public void runQuery(TreeMap<String, String> stateCapitalMap) {
        String input;
        do {
            System.out.print("\nEnter a US State to query its capital, or type 'terminate' to end:\n\n");
            input = scanner.nextLine().trim();

            if (stateCapitalMap.containsKey(input)) {
                System.out.println("The capital of " + input + " is " + stateCapitalMap.get(input));
            } else if (!input.equalsIgnoreCase("terminate")) {
                System.out.println("Invalid state name. Try again.");
            }
        } while (!input.equalsIgnoreCase("terminate"));
    }

    public static String[][] shuffle2DArray(String[][] array) {
        List<String[]> list = Arrays.asList(array);
        Collections.shuffle(list);
        return list.toArray(new String[0][]);
    }

    public static String[][] clone2D(String[][] array) {
        String[][] clone = new String[array.length][array[0].length];
        for (int i = 0; i < array.length; i++) {
            System.arraycopy(array[i], 0, clone[i], 0, array[i].length);
        }
        return clone;
    }

    public static void bubbleSort(String[][] array) {
        for (int i = 0; i < array.length - 1; i++) {
            for (int j = 0; j < array.length - i - 1; j++) {
                if (array[j][1].compareTo(array[j + 1][1]) > 0) {
                    String[] temp = array[j];
                    array[j] = array[j + 1];
                    array[j + 1] = temp;
                }
            }
        }
    }

    public static HashMap<String, String> toHashMap(String[][] array) {
        HashMap<String, String> map = new HashMap<>();
        for (String[] pair : array) {
            map.put(pair[0], pair[1]);
        }
        return map;
    }

    public static TreeMap<String, String> toTreeMap(HashMap<String, String> map) {
        TreeMap<String, String> treeMap = new TreeMap<>(String.CASE_INSENSITIVE_ORDER);
        treeMap.putAll(map);
        return treeMap;
    }

    public static void print2DArray(String[][] array) {
        for (String[] pair : array) {
            System.out.println("{" + pair[0] + ", " + pair[1] + "}");
        }
    }

    public static void printMap(Map<String, String> map) {
        for (Map.Entry<String, String> entry : map.entrySet()) {
            System.out.println("{" + entry.getKey() + ", " + entry.getValue() + "}");
        }
    }


}
