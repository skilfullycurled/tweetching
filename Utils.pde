String convertToBinary(int num, int len, String sep){
    
    String[] longbi = binary(num).split("");
    String binary = join(subset(longbi, longbi.length - len), sep);
    return binary;
}
