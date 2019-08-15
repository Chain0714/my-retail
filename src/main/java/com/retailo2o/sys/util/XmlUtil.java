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
import java.util.stream.Collectors;

public class XmlUtil {
    public static List<DataModel.Pair> parseSqlXml(File xml) throws DocumentException {
        List<DataModel.Pair> result = new ArrayList<>();
        SAXReader reader = new SAXReader();
        Document document = reader.read(xml);
        Element resultMap = document.getRootElement().element("resultMap");
        for (Iterator it = resultMap.elementIterator(); it.hasNext(); ) {
            Element element = null;
            try {
                element = (Element) it.next();
            } catch (Exception e) {
                break;
            }
            DataModel.Pair pair = new DataModel.Pair();
            for (Iterator inner = element.attributeIterator(); it.hasNext(); ) {
                Attribute attribute = null;
                try {
                    attribute = (Attribute) inner.next();
                } catch (Exception e) {
                    break;
                }
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
        return result.parallelStream().filter(o -> null != o.getColumn() || null != o.getField() || null != o.getType()).collect(Collectors.toList());
    }
}
