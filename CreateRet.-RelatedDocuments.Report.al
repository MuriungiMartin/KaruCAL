#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6697 "Create Ret.-Related Documents"
{
    Caption = 'Create Ret.-Related Documents';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Return to Vendor")
                    {
                        Caption = 'Return to Vendor';
                        field(VendorNo;VendorNo)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Vendor No.';
                            Lookup = true;

                            trigger OnLookup(var Text: Text): Boolean
                            begin
                                if Page.RunModal(0,Vend) = Action::LookupOK then
                                  VendorNo := Vend."No.";
                            end;

                            trigger OnValidate()
                            begin
                                if VendorNo <> '' then
                                  Vend.Get(VendorNo);
                            end;
                        }
                        field(CreatePurchRetOrder;CreatePRO)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Create Purch. Ret. Order';
                        }
                        field(CreatePurchaseOrder;CreatePO)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Create Purchase Order';
                        }
                    }
                    group(Replacement)
                    {
                        Caption = 'Replacement';
                        field(CreateSalesOrder;CreateSO)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Create Sales Order';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            CreatePRO := true;
            CreatePO := true;
            CreateSO := true;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        TempRetRelDoc.DeleteAll;

        if CreateSO then begin
          SOSalesHeader."Document Type" := SOSalesHeader."document type"::Order;
          Clear(CopyDocMgt);
          CopyDocMgt.SetProperties(true,false,false,true,true,false,false);
          CopyDocMgt.CopySalesDoc(Doctype::"Return Order",SROSalesHeader."No.",SOSalesHeader);
          TempRetRelDoc."Entry No." := 3;
          TempRetRelDoc."Document Type" := TempRetRelDoc."document type"::"Sales Order";
          TempRetRelDoc."No." := SOSalesHeader."No.";
          TempRetRelDoc.Insert;
        end;

        if CreatePRO then begin
          PROPurchHeader."Document Type" := PROPurchHeader."document type"::"Return Order";
          Clear(CopyDocMgt);
          CopyDocMgt.SetProperties(true,false,false,false,true,false,false);
          CopyDocMgt.CopyFromSalesToPurchDoc(VendorNo,SROSalesHeader,PROPurchHeader);
          TempRetRelDoc."Entry No." := 1;
          TempRetRelDoc."Document Type" := TempRetRelDoc."document type"::"Purchase Return Order";
          TempRetRelDoc."No." := PROPurchHeader."No.";
          TempRetRelDoc.Insert;
        end;

        if CreatePO then begin
          POPurchHeader."Document Type" := POPurchHeader."document type"::Order;
          Clear(CopyDocMgt);
          CopyDocMgt.SetProperties(true,false,false,false,true,false,false);
          CopyDocMgt.CopyFromSalesToPurchDoc(VendorNo,SROSalesHeader,POPurchHeader);
          TempRetRelDoc."Entry No." := 2;
          TempRetRelDoc."Document Type" := TempRetRelDoc."document type"::"Purchase Order";
          TempRetRelDoc."No." := POPurchHeader."No.";
          TempRetRelDoc.Insert;
        end;
    end;

    var
        Vend: Record Vendor;
        PROPurchHeader: Record "Purchase Header";
        POPurchHeader: Record "Purchase Header";
        SROSalesHeader: Record "Sales Header";
        SOSalesHeader: Record "Sales Header";
        TempRetRelDoc: Record "Returns-Related Document" temporary;
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        VendorNo: Code[20];
        DocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
        CreatePRO: Boolean;
        CreatePO: Boolean;
        CreateSO: Boolean;


    procedure SetSalesHeader(NewSROSalesHeader: Record "Sales Header")
    begin
        SROSalesHeader := NewSROSalesHeader;
    end;


    procedure ShowDocuments()
    begin
        if TempRetRelDoc.FindFirst then
          Page.Run(Page::"Returns-Related Documents",TempRetRelDoc);
    end;
}

