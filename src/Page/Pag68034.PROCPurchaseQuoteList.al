#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68034 "PROC-Purchase Quote List"
{
    ApplicationArea = Basic;
    CardPageID = "PROC-Purchase Quot Req. Header";
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61050;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Opening Date";"Expected Opening Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Closing Date";"Expected Closing Date")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Description";"Posting Description")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Control1102755137;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("Assign Vendor(s)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign Vendor(s)';
                    Image = Allocate;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        Vends: Record UnknownRecord61051;
                    begin
                        Clear(Vends);
                        Vends.Reset;
                        Vends.SetRange(Vends."Document Type","Document Type");
                        Vends.SetRange(Vends."Document No.","No.");
                        if Vends.Find('-') then;

                        Page.Run(62251,Vends);
                    end;
                }
                separator(Action1000000008)
                {
                }
                group(Status)
                {
                    Caption = 'Status';
                    action(Cancel)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Cancel';

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            if Confirm('Cancel Document?',false)=false then begin exit end;
                            Status:=Status::Cancelled;
                            Modify;

                        end;
                    }
                    action(Stop)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Stop';

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            if Confirm('Close Document?',false)=false then begin exit end;
                            Status:=Status::Closed;
                            Modify;

                        end;
                    }
                    action(Close)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Close';

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            /*
                            PurchHeader.RESET;
                            PurchHeader.SETRANGE(PurchHeader."Document Type",PurchHeader."Document Type"::Quote);
                            PurchHeader.SETRANGE(PurchHeader."Request for Quote No.","No.");
                            IF PurchHeader.FINDFIRST THEN
                              BEGIN
                                ERROR('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              END;
                            */
                            if Confirm('Close Document?',false)=false then begin exit end;
                            Status:=Status::Closed;
                            Modify;

                        end;
                    }
                    action(Release)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Release';
                        Image = ReleaseDoc;
                        Promoted = true;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            if Confirm('Release document?',false)=false then begin exit end;
                            //check if the document has any lines
                            Lines.Reset;
                            Lines.SetRange(Lines."Document Type","Document Type");
                            Lines.SetRange(Lines."Document No.","No.");
                            if Lines.FindFirst then
                              begin
                                repeat
                                  Lines.TestField(Lines.Quantity);
                                  //Lines.TESTFIELD(Lines."Direct Unit Cost");
                                  Lines.TestField("No.");
                                until Lines.Next=0;
                              end
                            else
                              begin
                                Error('Document has no lines');
                              end;

                            Purchaselines.Reset;
                            Purchaselines.SetRange(Purchaselines."RFQ No.","No.");

                            if Purchaselines.Find('-') then
                             begin
                               repeat
                            Purchaselines."RFQ Created":=true;
                            Purchaselines.Modify;
                            until Purchaselines.Next=0;

                            end;

                            Status:=Status::Released;
                            Modify;
                        end;
                    }
                    action(Reopen)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Reopen';
                        Image = ReOpen;
                        Promoted = true;
                        PromotedIsBig = true;

                        trigger OnAction()
                        begin
                            //check if the quotation for request number has already been used
                            PurchHeader.Reset;
                            PurchHeader.SetRange(PurchHeader."Document Type",PurchHeader."document type"::Quote);
                            PurchHeader.SetRange(PurchHeader."Procurement Request No.","No.");
                            if PurchHeader.FindFirst then
                              begin
                                Error('The Quotation for request is already tied to a Quotation. Cannot be Reopened');
                              end;

                            if Confirm('Reopen Document?',false)=false then begin exit end;
                            Status:=Status::Open;
                            Modify;
                        end;
                    }
                }
                action("&Print/Preview")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print/Preview';
                    Image = Print;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        // PQH.SETRECFILTER;
                        // PQH.SETFILTER(PQH."Document Type",'%1',"Document Type");
                        // PQH.SETFILTER("No.","No.");
                        // repVend.SETTABLEVIEW(PQH);
                        // repVend.RUN;

                        Vends.Reset;
                        Vends.SetRange(Vends."Document No.",Rec."No.");
                        if Vends.Find('-') then begin
                        Report.Run(Report::"Purchase Quote Request Report",true,false,Vends);
                        end;
                    end;
                }
                action("Get Purchase Requisition Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Purchase Requisition Lines';
                    Image = GetLines;
                    Promoted = true;
                    PromotedIsBig = true;
                    RunObject = Page "PROC-PRF Lines";
                    Visible = false;

                    trigger OnAction()
                    begin
                        Clear(GETLINES);
                        RFQ:="No.";
                        GETLINES.GetRFQ(RFQ);
                        GETLINES.RunModal();
                    end;
                }
            }
        }
    }

    var
        PurchHeader: Record "Purchase Header";
        PParams: Record UnknownRecord61053;
        Lines: Record UnknownRecord61052;
        PQH: Record UnknownRecord61050;
        repVend: Report "Purchase Quote Request Report";
        RFQ: Code[10];
        Purchaselines: Record "Purchase Line";
        GETLINES: Page "PROC-PRF Lines";
        Vends: Record UnknownRecord61051;
}

