package com.retailo2o.sys.util;

import com.retailo2o.sys.DataModel;
import org.dom4j.Attribute;
import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.Element;
import org.dom4j.io.SAXReader;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class XmlUtil {
    public static List<DataModel.Pair> parseSqlXml(File xml) throws DocumentException {
        List<DataModel.Pair> result = new ArrayList<>();
        SAXReader reader = new SAXReader();
        Document document = reader.read(xml);
        Element resultMap = document.getRootElement().element("resultMap");
        for (Iterator it = resultMap.elementIterator(); it.hasNext(); ) {
            Element element = null;
            element = (Element) it.next();
            DataModel.Pair pair = new DataModel.Pair();
            for (Iterator inner = element.attributeIterator(); inner.hasNext(); ) {
                Attribute attribute = null;
                attribute = (Attribute) inner.next();
                if ("column".equals(attribute.getName())) {
                    pair.setColumn(attribute.getText());
                }
                if ("property".equals(attribute.getName())) {
                    pair.setField(attribute.getText());
                }
                if ("jdbcType".equals(attribute.getName())) {
                    pair.setType(attribute.getText());
                }
            }
            result.add(pair);
        }
        return result;
    }
}
