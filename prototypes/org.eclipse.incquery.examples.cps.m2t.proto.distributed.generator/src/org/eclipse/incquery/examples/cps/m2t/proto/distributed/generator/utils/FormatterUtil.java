package org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.utils;

import org.eclipse.incquery.examples.cps.m2t.proto.distributed.generator.exceptions.CPSGeneratorException;
import org.eclipse.jdt.core.ToolFactory;
import org.eclipse.jdt.core.formatter.CodeFormatter;
import org.eclipse.jface.text.BadLocationException;
import org.eclipse.jface.text.Document;
import org.eclipse.jface.text.IDocument;
import org.eclipse.text.edits.MalformedTreeException;
import org.eclipse.text.edits.TextEdit;

public class FormatterUtil {

	
	public static String formatCode(CharSequence code) throws CPSGeneratorException{
		CodeFormatter formatter = ToolFactory.createCodeFormatter(null);
		
		TextEdit textEdit = formatter.format(CodeFormatter.K_COMPILATION_UNIT, code.toString(), 0, code.length(), 0, null);
		IDocument doc = new Document(code.toString());
		try {
			textEdit.apply(doc);
		} catch (MalformedTreeException e) {
			throw new CPSGeneratorException("Cannot complete codeformatting", e);
		} catch (BadLocationException e) {
			throw new CPSGeneratorException("Cannot complete codeformatting", e);
		}
		
		return doc.get();
	}
}
