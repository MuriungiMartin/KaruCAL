#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68308 "CAT-Catering Requisition"
{
    PageType = Card;
    SourceTable = UnknownTable61146;
    SourceTableView = where(Status=filter(New));

    layout
    {
        area(content)
        {
            group(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Request Plan No";"Request Plan No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                                GetRequestPlan();
                    end;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date Requisitioned";"Date Requisitioned")
                {
                    ApplicationArea = Basic;
                }
                field("Date Required";"Date Required")
                {
                    ApplicationArea = Basic;
                }
                field("Requisitioned By";"Requisitioned By")
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Entered By";"Entered By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("User Name";"User Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000008;"PROC-Store Requisition Line UP")
            {
                SubPageLink = "No."=field("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Requisition Actions")
            {
                Caption = 'Requisition Actions';
                action("Send for Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send for Approval';
                    Image = Approval;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        //check the status of the requisition
                            SendForApproval();
                    end;
                }
                action("Send for Approval && Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send for Approval && Print';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        SendForApproval();
                        Report.Run(52207,true,true,InternalRequisition);
                    end;
                }
                action("Print / Preview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Print / Preview';
                    Image = PrintCheck;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        InternalRequisition.Reset;
                        InternalRequisition.SetRange(InternalRequisition."No.",Rec."No.");
                        Report.Run(52207,true,true,InternalRequisition);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //set the default values
            "Entered By":=Database.UserId;
            getUserName();
             Date:=Today;
             Department:='91';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    var
        "Dimension Value": Record "Dimension Value";
        User: Record User;
        "Department Name": Text[50];
        "User Name": Text[50];
        InternalRequisition: Record UnknownRecord61146;
        ProcHeader: Record UnknownRecord61153;
        ProcLine: Record UnknownRecord61154;
        ReqLine: Record UnknownRecord61147;
        LastLine: Integer;
        IssueLine: Record UnknownRecord61149;
        IssueHeader: Record UnknownRecord61148;


    procedure getDepartmentName()
    begin
        //retrieve the department name from the database
            "Dimension Value".Reset;
           // "Dimension Value".SETRANGE("Dimension Value"."Global Dimension No.",1);
            "Dimension Value".SetRange("Dimension Value".Code,Department);
            if "Dimension Value".Find('-') then "Department Name":="Dimension Value".Name else "Department Name":='';
    end;


    procedure getUserName()
    begin
        //retrieve the user name from the database
            User.Reset;
            if User.Get("Entered By") then "User Name":=User."User Name" else "User Name":='';
    end;


    procedure SendForApproval()
    begin
        //check the status of the requisition in the database
        if Rec.Status=Rec.Status::New then
            begin
                ReqLine.SetRange(ReqLine."No.","No.");
                if ReqLine.Find('-') then
                begin
                  repeat
                    if ReqLine.Qty<1 then
                      begin
                        Error('You Must Enter The Qty In All Lines')
                      end;
                    if ReqLine.Qty > ReqLine."Remaining Qty" then
                      begin
                        Error('Requested Qty Must Be Less Than Remaining Qty')
                      end;

                  until ReqLine.Next=0;
                end;
                InternalRequisition.Reset;
                InternalRequisition.SetRange(InternalRequisition."No.",Rec."No.");
                Rec.Status:=Rec.Status::Pending;
                Rec."Prepared By":=Database.UserId;
                Rec."Prepared Date":=Today;
                Rec."Prepared Time":=Time;
                Rec.Modify;
                Message('The Internal Requisition has been SENT FOR APPROVAL');
            end
        else
            begin
                Error('Only New Internal Requisitions can be send for APPROVAL');
            end;
    end;


    procedure GetRequestPlan()
    begin
         // ----BKK------------

        ProcHeader.SetRange(ProcHeader."No.","Request Plan No");
        if ProcHeader.Find('-') then
          begin
            Department:=ProcHeader.Department;
            ProcHeader.Modify;
            ProcLine.SetRange(ProcLine."No.",ProcHeader."No.") ;
            if ProcLine.Find('-') then
                 ReqLine.SetRange(ReqLine."No.","No.");
                 if ReqLine.Find('-') then
                    begin
                      repeat
                        ReqLine.Delete;
                      until ReqLine.Next=0;
                    end;
               LastLine:=1000;

               begin
                 repeat
                   ReqLine.Init;
                   ReqLine."No.":="No.";
                   ReqLine."Line No.":=LastLine;
                   ReqLine.Type:=ProcLine.Type;
                   ReqLine."Type No.":=ProcLine."Type No.";
                   ReqLine.Description:= ProcLine.Description;
                   ReqLine.Purpose:=ProcLine.Purpose;
                   ReqLine."Remaining Qty":=ProcLine."Remaining Qty";
                   //ReqLine."Remaining Qty":=ReqLine.Qty;
                   ReqLine."Unit of Measure":=ProcLine."Unit of Measure";
                   ReqLine."Units per Unit of Measure":=ProcLine."Units per Unit of Measure";
                   ReqLine."Unit Direct Cost":=ProcLine."Unit Direct Cost";
                   ReqLine."Total Units Due":=ProcLine."Total Units Due";
                   //ReqLine."Total Cost":=ProcLine."Total Cost";
                   ReqLine."Total Units Due":=ProcLine."Remaining Qty" *  ReqLine."Units per Unit of Measure";
                   ReqLine."Total Cost":= ReqLine."Total Units Due" *  ReqLine."Unit Direct Cost";

                   ReqLine.Validate(ReqLine.Qty);
                   ReqLine.Insert;
                   LastLine:=LastLine + 1000;

                 until ProcLine.Next=0;
               end;
             end;
    end;


    procedure GetRemainingQty()
    begin

        IssueHeader.SetRange(IssueHeader."Plan No","Request Plan No");
        IssueLine.SetRange(IssueLine."No.",IssueHeader."No.");
        if IssueLine.Find('-') then
          begin
           repeat
             ReqLine."Remaining Qty":=IssueLine.Qty;
             ReqLine.Modify;
             until IssueLine.Next=0;
           end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //display the department name
            getDepartmentName();
        //get the user name
            getUserName();
    end;
}

