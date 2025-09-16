#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68033 "PROC-PRF Lines"
{
    PageType = Card;
    SourceTable = "Purchase Line";
    SourceTableView = where("Document Type 2"=const(Requisition),
                            "RFQ Created"=const(false),
                            "Document Type"=const(Quote));

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type 2";"Document Type 2")
                {
                    ApplicationArea = Basic;
                }
                field("RFQ No.";"RFQ No.")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("RFQ Created";"RFQ Created")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Line No.";"Line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Create Quotation Lines")
            {
                ApplicationArea = Basic;
                Caption = 'Create Quotation Lines';
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    /*PQLines.RESET;
                    PQLines.SETRANGE(PQLines."Document No.","RFQ No.");
                    IF PQLines.FIND('-') THEN
                    ERROR('The Lines you have selected exist in another RFQ please delete the lines before reselecting again');
                    */// now use  getsrfq
                    Reset;
                    SetRange(Select,true);
                    //SETRANGE(Status,Status::Released);
                    SetRange("RFQ Created",false);
                    SetRange("Document Type 2","document type 2"::Requisition);
                    if Find('-') then begin
                     repeat
                     PQLines.Init;
                     PQLines."Document Type":="Document Type";
                     PQLines."Document No.":=getsrfq;
                     PQLines."Line No.":="Line No.";
                     PQLines.Type:=Type;
                     PQLines."No.":="No.";
                     PQLines."Location Code":=PQLines."Location Code";
                     PQLines."Expected Receipt Date":="Expected Receipt Date";
                     PQLines.Description:=Description;
                     PQLines."Unit of Measure":="Unit of Measure";
                     PQLines.Quantity:=Quantity;
                     PQLines.Amount:=Amount;
                     PQLines."Shortcut Dimension 1 Code":="Shortcut Dimension 1 Code";
                     PQLines."Shortcut Dimension 2 Code":="Shortcut Dimension 2 Code";
                     PQLines."Unit Cost":="Unit Cost";
                     PQLines."Line Amount":="Line Amount";
                     PQLines."Order Date":="Order Date";
                     "Line Created":=true;
                     PQLines.Insert;
                     "RFQ No.":=getsrfq;
                     Modify;
                     until Next=0;
                     end;
                    
                    if Confirm('All Lines Successfully Selected, Exit Window?', true) = true then begin
                    CurrPage.Close();
                    
                    
                    
                    end;

                end;
            }
        }
    }

    var
        PQLines: Record UnknownRecord61052;
        rfqno: Code[10];
        getsrfq: Code[10];


    procedure GetRFQ(RFQ: Code[10])
    begin
        getsrfq:=RFQ;
    end;
}

