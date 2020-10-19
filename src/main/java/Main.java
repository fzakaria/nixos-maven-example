import com.vdurmont.emoji.EmojiParser;

public class Main {
	public static void main(String[] args) {
		String str = "NixOS :grinning: is super cool :smiley:!";
		String result = EmojiParser.parseToUnicode(str);
		System.out.println(result);
	}
}