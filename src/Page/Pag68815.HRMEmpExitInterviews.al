#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68815 "HRM-Emp. Exit Interviews"
{
    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Exit Interview';
    SourceTable = UnknownTable61215;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Exit Clearance No";"Exit Clearance No")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Requester";"Clearance Requester")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Re Employ In Future";"Re Employ In Future")
                {
                    ApplicationArea = Basic;
                }
                field("Nature Of Separation";"Nature Of Separation")
                {
                    ApplicationArea = Basic;
                }
                field("Reason For Leaving (Other)";"Reason For Leaving (Other)")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Clearance";"Date Of Clearance")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Leaving";"Date Of Leaving")
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Form Submitted";"Form Submitted")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control1000000013;"HRM-Asset Return Form")
            {
                SubPageLink = "Employee No."=field("Employee No.");
            }
        }
        area(factboxes)
        {
            systempart(Control1102755008;Outlook)
            {
            }
            systempart(Control1102755010;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Exit Interview")
            {
                Caption = '&Exit Interview';
                action(Form)
                {
                    ApplicationArea = Basic;
                    Caption = 'Form';
                    Image = Form;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if DoclLink.Get("Employee No.",'Exit Interview') then begin
                        DoclLink.PlaceFilter(true,DoclLink."Employee No");
                        Page.RunModal(39005537,DoclLink);
                        end else begin
                        DoclLink.Init;
                        DoclLink."Employee No":="Employee No.";
                        DoclLink."Document Description":='Exit Interview';
                        DoclLink.Insert;
                        Commit;
                        DoclLink.PlaceFilter(true,DoclLink."Employee No");
                        Page.RunModal(39005537,DoclLink);
                        end;
                    end;
                }
                action("Departmental Clearance")
                {
                    ApplicationArea = Basic;
                    Caption = 'Departmental Clearance';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Exit Interview Checklist";
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin

        if HREmp.Get("Employee No.") then begin
        JobTitle:=HREmp."Job Title";
        sUserID:=HREmp."User ID";
        end else begin
        JobTitle:='';
        sUserID:='';
        end;


        SetRange("Employee No.");
        DAge:='';
        DService:='';
        DPension:='';
        DMedical:='';

        RecalcDates;
    end;

    var
        JobTitle: Text[30];
        Supervisor: Text[60];
        HREmp: Record UnknownRecord61188;
        Dates: Codeunit "HR Dates";
        DAge: Text[100];
        DService: Text[100];
        DPension: Text[100];
        DMedical: Text[100];
        HREmpForm: Page "HRM-Employee (B)";
        sUserID: Code[30];
        DoclLink: Record UnknownRecord61224;
        InteractTemplLanguage: Record "Interaction Tmpl. Language";
        D: Date;
        Misc: Record "Misc. Article Information";
        Text19062217: label 'Misc Articles';


    procedure RecalcDates()
    begin
        //Recalculate Important Dates
          if (HREmp."Date Of Leaving" = 0D) then begin
            if  (HREmp."Date Of Birth" <> 0D) then
            DAge:= Dates.DetermineAge(HREmp."Date Of Birth",Today);
            if  (HREmp."Date Of Join" <> 0D) then
            DService:= Dates.DetermineAge(HREmp."Date Of Join",Today);
          //  IF  (HREmp."Pension Scheme Join Date" <> 0D) THEN
           // DPension:= Dates.DetermineAge(HREmp."Pension Scheme Join Date",TODAY);
            if  (HREmp."Medical Scheme Join Date" <> 0D) then
            DMedical:= Dates.DetermineAge(HREmp."Medical Scheme Join Date",Today);
            //MODIFY;
          end else begin
            if  (HREmp."Date Of Birth" <> 0D) then
            DAge:= Dates.DetermineAge(HREmp."Date Of Birth",HREmp."Date Of Leaving");
            if  (HREmp."Date Of Join" <> 0D) then
            DService:= Dates.DetermineAge(HREmp."Date Of Join",HREmp."Date Of Leaving");
           // IF  (HREmp."Pension Scheme Join Date" <> 0D) THEN
           // DPension:= Dates.DetermineAge(HREmp."Pension Scheme Join Date",HREmp."Date Of Leaving the Company");
            if  (HREmp."Medical Scheme Join Date" <> 0D) then
            DMedical:= Dates.DetermineAge(HREmp."Medical Scheme Join Date",HREmp."Date Of Leaving");
            //MODIFY;
          end;
    end;

    local procedure EmployeeNoOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        FilterGroup := 2;
        Misc.SetRange(Misc."Employee No.","Employee No.");
        FilterGroup := 0;
        if Misc.Find('-') then;
        CurrPage.Update(false);
    end;
}

