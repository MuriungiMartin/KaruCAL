#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6699 "Move Negative Sales Lines"
{
    Caption = 'Move Negative Sales Lines';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Order && Invoice")
                    {
                        Caption = 'Order && Invoice';
                        field(DropDownForOrderAndInvoice;ToDocType)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To Document Type';
                            Editable = DropDownForOrderAndInvoiceEdit;
                            OptionCaption = ',,,,Return Order,Credit Memo';
                        }
                    }
                    group("Return Order && Credit Memo ")
                    {
                        Caption = 'Return Order && Credit Memo ';
                        field(DropDownForRetOrderAndCrMemo;ToDocType2)
                        {
                            ApplicationArea = Basic;
                            Caption = 'To Document Type';
                            Editable = DropDownForRetOrderAndCrMemoEd;
                            OptionCaption = ',,Order,Invoice';
                        }
                    }
                    label(Control4)
                    {
                        ApplicationArea = Basic;
                        CaptionClass = Text19037468;
                        MultiLine = true;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DropDownForOrderAndInvoiceEdit := true;
            DropDownForRetOrderAndCrMemoEd := true;
        end;

        trigger OnOpenPage()
        begin
            with FromSalesHeader do
              case "Document Type" of
                "document type"::Order:
                  begin
                    ToDocType := Todoctype::"Return Order";
                    ToDocType2 := Todoctype2::Order;
                    FromDocType := Fromdoctype::Order;
                    DropDownForRetOrderAndCrMemoEd := false;
                  end;
                "document type"::Invoice:
                  begin
                    ToDocType := Todoctype::"Credit Memo";
                    ToDocType2 := Todoctype2::Invoice;
                    FromDocType := Fromdoctype::Invoice;
                    DropDownForRetOrderAndCrMemoEd := false;
                  end;
                "document type"::"Return Order":
                  begin
                    ToDocType2 := Todoctype2::Order;
                    ToDocType := Todoctype::"Return Order";
                    FromDocType := Fromdoctype::"Return Order";
                    DropDownForOrderAndInvoiceEdit := false;
                  end;
                "document type"::"Credit Memo":
                  begin
                    ToDocType2 := Todoctype2::Invoice;
                    ToDocType := Todoctype::"Credit Memo";
                    FromDocType := Fromdoctype::"Credit Memo";
                    DropDownForOrderAndInvoiceEdit := false;
                  end;
              end;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CopyDocMgt.SetProperties(true,false,true,true,true,false,false);
        if (FromDocType = Fromdoctype::"Return Order") or (FromDocType = Fromdoctype::"Credit Memo") then
          ToDocType := ToDocType2;
        ToSalesHeader."Document Type" := CopyDocMgt.SalesHeaderDocType(ToDocType);
        CopyDocMgt.CopySalesDoc(FromDocType,FromSalesHeader."No.",ToSalesHeader);
    end;

    var
        FromSalesHeader: Record "Sales Header";
        ToSalesHeader: Record "Sales Header";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ToDocType: Option ,,"Order",Invoice,"Return Order","Credit Memo";
        ToDocType2: Option ,,"Order",Invoice,"Return Order","Credit Memo";
        FromDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo";
        Text001: label '%1 %2 has been created. Do you want to view the created document?';
        [InDataSet]
        DropDownForRetOrderAndCrMemoEd: Boolean;
        [InDataSet]
        DropDownForOrderAndInvoiceEdit: Boolean;
        Text19037468: label 'When you move a negative sales line to your selected document type, the quantity of the line on the selected document becomes positive.';


    procedure SetSalesHeader(var NewFromSalesHeader: Record "Sales Header")
    begin
        FromSalesHeader := NewFromSalesHeader;
    end;


    procedure ShowDocument()
    begin
        Commit;
        if ToSalesHeader.Find then
          if Confirm(Text001,true,ToSalesHeader."Document Type",ToSalesHeader."No.") then
            CopyDocMgt.ShowSalesDoc(ToSalesHeader);
    end;


    procedure InitializeRequest(NewFromDocType: Option;NewToDocType: Option;NewToDocType2: Option)
    begin
        FromDocType := NewFromDocType;
        ToDocType := NewToDocType;
        ToDocType2 := NewToDocType2;
    end;
}

