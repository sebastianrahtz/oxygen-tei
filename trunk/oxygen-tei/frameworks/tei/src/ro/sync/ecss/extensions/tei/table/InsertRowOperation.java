/**
 * Copyright 2011 Syncro Soft SRL, Romania. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are
 * permitted provided that the following conditions are met:

 *    1. Redistributions of source code must retain the above copyright notice, this list of
 *       conditions and the following disclaimer.
 * 
 *    2. Redistributions in binary form must reproduce the above copyright notice, this list
 *       of conditions and the following disclaimer in the documentation and/or other materials
 *       provided with the distribution.
 * 
 * THIS SOFTWARE IS PROVIDED BY Syncro Soft SRL ''AS IS'' AND ANY EXPRESS OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 * FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL Syncro Soft SRL OR
 * CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
 * ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
 * ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * The views and conclusions contained in the software and documentation are those of the
 * authors and should not be interpreted as representing official policies, either expressed
 * or implied, of Syncro Soft SRL.
 */
package ro.sync.ecss.extensions.tei.table;

import ro.sync.ecss.extensions.api.node.AuthorElement;
import ro.sync.ecss.extensions.commons.table.operations.InsertRowOperationBase;
import ro.sync.ecss.extensions.tei.TEIDocumentTypeHelper;

/**
 * Operation used to insert a table row for TEI documents. 
 */
public class InsertRowOperation extends InsertRowOperationBase implements TEIConstants {
  
  /**
   * Constructor.
   */
  public InsertRowOperation() {
    super(new TEIDocumentTypeHelper());
  }
    
  /**
   * @see ro.sync.ecss.extensions.commons.table.operations.InsertRowOperationBase#getCellElementName(AuthorElement, int)
   */
  @Override
  protected String getCellElementName(AuthorElement tableElement, int columnIndex) {
    return ELEMENT_NAME_CELL;
  }

  /**
   * @see ro.sync.ecss.extensions.commons.table.operations.InsertRowOperationBase#getRowElementName(AuthorElement)
   */
  @Override
  protected String getRowElementName(AuthorElement tableElement) {
    return ELEMENT_NAME_ROW;
  }
  
  /**
   * @see ro.sync.ecss.extensions.commons.table.operations.InsertRowOperationBase#getIgnoredAttributes()
   */
  @Override
  protected String[] getIgnoredAttributes() {
    return new String[] {ATTRIBUTE_NAME_XML_ID, ATTRIBUTE_NAME_ID, ATTRIBUTE_NAME_ROWS };
  }
  
  /**
   * @see ro.sync.ecss.extensions.commons.table.operations.InsertRowOperationBase#useCurrentRowTemplateOnInsert()
   */
  @Override
  protected boolean useCurrentRowTemplateOnInsert() {
    return true;
  }
}