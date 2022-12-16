import java.io.*;
import java.util.Hashtable;

public class Assembler {


    //path to source and destination files
    private static File sourceFile, destFile;
    private static Hashtable<String, Integer>  labelList = new Hashtable<String, Integer>();
    private static Hashtable<String, Integer>  instructionList = new Hashtable<String, Integer>();
    private static int currentLine = 0; //
    private static int codeLineCnt = 0; //ProgramCounter


    public static void main(String[] args) {
        if (args.length == 0) {
            System.out.println("no filename specified");
            System.exit(-1);
        }
        sourceFile = new File(args[0]);

        if (args.length == 1) {
            if (args[0].equalsIgnoreCase("-h") || args[0].equalsIgnoreCase("--help")) {
                System.out.println("Useage:");
                System.out.println("java Aassembler [options]");
                System.out.println("options:");
                System.out.println("<source_code_path> <dest_path>:");
                System.out.println("\tAssemble source code to dest. For exaple .\\bin\\test1.asm .\\bin\\test1.prog");
                System.out.println("<source_code_path>:");
                System.out.println("\tAssemble source code to dest file a.prog");
                System.out.println("-h(or --help):");
                System.out.println("\tShow this help");
                System.exit(0);
            } else {
                if (sourceFile.getParent() != null)
                    destFile = new File(sourceFile.getParent().concat(File.separator).concat("a.prog"));
                else
                    destFile = new File("a.prog");
            }
        } else if (args.length == 2) {
            destFile = new File(args[1]);
        }


        if (!destFile.exists())
            try {
                destFile.createNewFile();
            } catch (IOException e) {
                System.out.println("Create machine language file error");
                e.printStackTrace();
            }
        System.out.println("assemble filename :" + sourceFile.getName());
        System.out.println("machine language filename : " + destFile.getName());

        initialInstructionList();
        findLabels(sourceFile, destFile);
        assembleFile(sourceFile, destFile);
        //System.out.println(labelList);
        }

    private static void initialInstructionList() {
        instructionList.put("HLT", 63);   //111111
        instructionList.put("LOAD", 1);   //000001
        instructionList.put("STORE", 2);  //000010
        instructionList.put("ADD", 3);    //000011
        instructionList.put("SUB", 4);    //000100
        instructionList.put("LSR", 5);    //000101
        instructionList.put("LSL", 6);    //000110
        instructionList.put("RSR", 7);    //000111
        instructionList.put("RSL", 8);    //001000
        instructionList.put("MOV", 9);    //001001
        instructionList.put("MUL", 10);   //001010
        instructionList.put("DIV", 11);   //001011
        instructionList.put("MOD", 12);   //001100
        instructionList.put("AND", 13);   //001101
        instructionList.put("OR", 14);    //001110
        instructionList.put("XOR", 15);   //001111
        instructionList.put("NOT", 16);   //010000
        instructionList.put("CMP", 17);   //010001
        instructionList.put("INC", 18);   //010010
        instructionList.put("DEC", 19);   //010011
        instructionList.put("BRZ", 33);   //100001
        instructionList.put("BRN", 34);   //10010
        instructionList.put("BRC", 35);   //100011
        instructionList.put("BRO", 36);   //100100
        instructionList.put("BRA", 37);   //100101
        instructionList.put("JMP", 38);   //100110
        instructionList.put("RET", 39);   //100111
    }

    private static void findLabels(File sourceFile, File destFile) {
        String line = new String();
        BufferedReader sourceBr;
        BufferedWriter destBw;

        String parsedLine[] = new String[5];

        currentLine = 0;
        codeLineCnt = 0;
        System.out.println("=====Pass one: Finding Labels=====");

        try {
            sourceBr = new BufferedReader(new FileReader(sourceFile));
            destBw = new BufferedWriter(new FileWriter(destFile));
            boolean endOfFile = false;
            while(!endOfFile)
            {
                line = sourceBr.readLine();
                if(line != null)
                {
                    currentLine++;
                    codeLineCnt++;
                    line = line.toUpperCase();
                    parsedLine = parseLine(currentLine, line);
                    if(parsedLine[0] != null)
                    {
                        //translatedLine = translateLine(currentLine, parsedLine);
                        //System.out.print("translatedLine: "+translatedLine);
                        //destBw.write(translatedLine);
                        //destBw.newLine();
                        //System.out.println(" wrote");
                    }
                    else
                    {
                        codeLineCnt--;
                        //System.out.println("Non-Code line, skiped");
                    }
                }
                else
                    endOfFile = true;
            }
            sourceBr.close();
            destBw.close();
            System.out.println("Labels found: ");
            System.out.println(labelList);


        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }


    private static String[] parseLine(int currentLine, String line) {
        String temp[];
        int i, p;
        String parsedLine[] = new String[5];
        //System.out.println("parsing: "+line);
        temp = line.split("[\\s,]");
        //System.out.println("string length"+temp.length);
        p = 0;
        boolean labelFound = false;
        for(i=0; i< temp.length; i++)
        {
            if(temp[i].contains(";"))
                break;
            else if(temp[i].length()>0)
            {
                if(temp[i].contains(":"))
                {
                    String  temp1[] = null;

                    if(!labelFound)
                        labelFound = true;
                    else
                        reportSyntaxError(currentLine,"found multi-labels");

                    temp1 = temp[i].split(":");
                    if(temp1.length == 1)
                    {
                        labelList.put(temp1[0], codeLineCnt);
                    }
                    else
                    if(temp1.length == 2)
                    {
                        labelList.put(temp1[0], codeLineCnt);
                        parsedLine[p++] = temp1[1];
                    }
                    else
                    {
                        reportSyntaxError(currentLine,"error when parsing labels");
                    }
                }
                else
                    parsedLine[p++] = temp[i];
            }
        }
        System.out.print("parsed Line "+currentLine+": ");
        for(i=0; i<p; i++)
            System.out.print(parsedLine[i]+" ");
        System.out.println("");

        return parsedLine;
    }


    private static void reportSyntaxError(int lineNum, String errReason) {
        System.out.println("error at line:"+lineNum+", "+ errReason);
        System.exit(-1);
    }


    private static void assembleFile(File sourceFile, File destFile) {

        String line = new String();
        BufferedReader sourceBr;
        BufferedWriter destBw;

        String parsedLine[] = new String[5];
        String translatedLine;

        currentLine = 0;
        codeLineCnt = 0;
        System.out.println("=====Pass two: translate=====");

        try {
            sourceBr = new BufferedReader(new FileReader(sourceFile));
            destBw = new BufferedWriter(new FileWriter(destFile));
            boolean endOfFile = false;
            while(!endOfFile)
            {
                line = sourceBr.readLine();
                if(line != null)
                {
                    currentLine++;
                    codeLineCnt++;
                    line = line.toUpperCase();
                    parsedLine = parseLine(currentLine, line);
                    if(parsedLine[0] != null)
                    {
                        translatedLine = translateLine(currentLine, parsedLine);
                        System.out.print("translatedLine: "+translatedLine);
                        destBw.write(translatedLine);
                        destBw.newLine();
                        System.out.println(" wrote");
                    }
                    else
                    {
                        codeLineCnt--;
                        System.out.println("Non-Code line, skiped");
                    }
                }
                else
                    endOfFile = true;
            }
            sourceBr.close();
            destBw.close();
            System.out.println("assemble complete ");



        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static boolean verifyShiftValue(String opcode, int imediatValue){
        boolean valid = true;
        if(opcode.equals("LSR")||opcode.equals("LSL")||opcode.equals("RSR")||opcode.equals("RSL")){
            if(!(imediatValue > 0 && imediatValue < 7)){
                valid = false;
            }
        }
        return valid;
    }

    private static String translateLine(int currentLine, String[] parsedLine) {
        String translatedLine = null;
        String op = parsedLine[0];
        String register = parsedLine[1];
        String immediateValue = parsedLine[2];

        Integer opCodeInstruction = instructionList.get(op);

        if ( opCodeInstruction != null){
            String opCodeInstructionBinary = Integer.toBinaryString(opCodeInstruction);
            translatedLine= saturateWithZeros(opCodeInstructionBinary.length())+opCodeInstructionBinary;
            translatedLine += getRegisterType(register);
            if ((verifyImmediateValue(immediateValue) == true)&&(verifyShiftValue(op, Integer.parseInt(immediateValue)))){
                String immediateValueBinary = Integer.toBinaryString(Integer.parseInt(immediateValue));

                translatedLine +=saturateWithZeros(immediateValueBinary.length())+ immediateValueBinary;
            }
            else reportSyntaxError(currentLine, "Immediate Value out of bounds: " + immediateValue);
        }
        else {
            reportSyntaxError(currentLine, "unkown Instruction:" + op);
        }

        // translatedLine = 6 bits - opCode + 1 bit - register + 9 bits - immediate value

        return translatedLine;
        }

   private static String saturateWithZeros(Integer noBitsLength){
        String zeros="";
        Integer remainingBits = 9- noBitsLength;
        while(remainingBits>0){
            zeros+="0";
            remainingBits--;
        }
        return zeros;
   }
    private static String getRegisterType(String register){
        String registerType = "";

        switch (register)
        {
            case "X":
                registerType = "0";
                break;
            case "Y":
                registerType = "1";
                break;
        }

        return registerType;
    }

    private static boolean verifyImmediateValue (String immediateValue){
        boolean valid = true;
        Integer immediateValueInt =  Integer.parseInt(immediateValue);

        if (!(immediateValueInt >= 0 && immediateValueInt <= 511)){
            valid = false;
        }

        return valid;
    }

}
