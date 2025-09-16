#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77333 "HRM-Clearance Form (Report)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HRM-Clearance Form (Report).rdlc';
    Caption = 'Staff Clearance Form';
    UseRequestPage = true;

    dataset
    {
        dataitem(Clearances;UnknownTable77306)
        {
            DataItemTableView = sorting(Sequence) order(ascending);
            RequestFilterFields = "Academic Year",Semester,"PF. No.";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(ClearanceCode;Clearances."Clearance Level Code")
            {
            }
            column(CodeCaption;ACAClearanceLevelCodes.Caption)
            {
            }
            column(ApprovalTitle;ACAClearanceLevelCodes."Approval Title")
            {
            }
            column(ApprovalStatement;ACAClearanceLevelCodes."Approval Statement")
            {
            }
            column(sAdmissionDate;hrEmp."Date Of Join")
            {
            }
            column(sNo;hrEmp."No.")
            {
            }
            column(SName;hrEmp."First Name"+' '+hrEmp."Middle Name"+' '+hrEmp."Last Name")
            {
            }
            column(intake;'')
            {
            }
            column(ProgEnd;hrEmp."Date Of Join")
            {
            }
            column(status;hrEmp.Status)
            {
            }
            column(RefundonPV_Customer;'')
            {
            }
            column(Bal;'')
            {
            }
            column(currProg;'')
            {
            }
            column(currDate;Today)
            {
            }
            column(compName;' P.O. BOX 15653 - 00503 KARATINA TEL: +254-020-2071391')
            {
            }
            column(progName;Prog.Description)
            {
            }
            column(deptName;DimVal.Name)
            {
            }
            column(LastInDate;LastInDate)
            {
            }
            column(footer1;footer1)
            {
            }
            column(footer2;footer2)
            {
            }
            column(footer3;footer3)
            {
            }
            column(Seq;Clearances.Sequence)
            {
            }
            column(class;'')
            {
            }
            column(Statuses;Statuses)
            {
            }
            column(ApprovalDate;ApprovalDateTime)
            {
            }
            column(RegistraApprovalDateTime;RegistraApprovalDateTime)
            {
            }
            column(Pics;UserSetup."User Signature")
            {
            }
            column(RegistrarStatuses;RegistrarStatuses)
            {
            }
            column(RegistrarName;RegistrarNames)
            {
            }
            column(SeqOrder;ACAClearanceLevelCodes.Sequence)
            {
            }
            column(RegistrarSignature;UserSetupRegistrar."User Signature")
            {
            }
            dataitem(ClearanceProperty;UnknownTable77301)
            {
                DataItemLink = "Clearance Level Code"=field("Clearance Level Code"),"PF. No."=field("PF. No."),Semester=field(Semester),"Academic Year"=field("Academic Year");
                column(ReportForNavId_17; 17)
                {
                }
                column(PropName;ClearanceProperty."Property Description")
                {
                }
                column(PropValue;ClearanceProperty."Property Value")
                {
                }
                column(TotPropertyValue;ClearanceProperty."Total Property Value")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                Clear(ApprovalDateTime);
                ACAClearanceLevelCodes.Reset;
                ACAClearanceLevelCodes.SetRange("Clearance Level Code",Clearances."Clearance Level Code");
                if ACAClearanceLevelCodes.Find('-') then;
                Clear(hrEmp);
                if hrEmp.Get(Clearances."PF. No.") then;
                Clear(LastInDate);
                if hrEmp."Contract End Date" <> 0D then
                 LastInDate:=hrEmp."Contract End Date";
                Clear(DeptName);
                DimVal.Reset;
                DimVal.SetRange(DimVal."Dimension Code",'DEPARTMENT');
                DimVal.SetRange(DimVal.Code,hrEmp."Department Code");
                if DimVal.Find('-') then;
                Clear(Statuses);
                Clear(RegistraApprovalDateTime);
                Clear(RegistrarStatuses);
                UserSetup.Reset;
                UserSetup.SetRange("User ID",Clearances."Clear By ID");
                //  UserSetup.SETRANGE("Is Registrar",TRUE);
                if Clearances.Status=Clearances.Status::Cleared then begin
                  if UserSetup.Find('-') then UserSetup.CalcFields("User Signature");
                  Statuses:='APPROVED';
                  ApprovalDateTime:=CreateDatetime(Clearances."Last Date Modified",Clearances."Last Time Modified");

                end else if Clearances.Status=Clearances.Status::Rejected then  Statuses:='REJECTED'
                else  Statuses:='PENDING';
                if ((Clearances.Status=Clearances.Status::Cleared) and (Clearances.Cleared=false)) then begin
                    CurrReport.Skip;
                  end;
                  Clear(RegistraApprovalDateTime);
                  UserSetupRegistrar.Reset;
                  Clear(RegistrarNames);
                  ACAClearanceApprovalEntriesRegistrar.Reset;
                  ACAClearanceApprovalEntriesRegistrar.SetRange("PF. No.",Clearances."PF. No.");
                  ACAClearanceApprovalEntriesRegistrar.SetRange("Priority Level",ACAClearanceApprovalEntriesRegistrar."priority level"::"Final level");
                  ACAClearanceApprovalEntriesRegistrar.SetRange(Cleared,true);
                  ACAClearanceApprovalEntriesRegistrar.SetRange(Status,ACAClearanceApprovalEntriesRegistrar.Status::Cleared);
                  if ACAClearanceApprovalEntriesRegistrar.Find('-') then begin
                      RegistraApprovalDateTime:=CreateDatetime(ACAClearanceApprovalEntriesRegistrar."Last Date Modified",ACAClearanceApprovalEntriesRegistrar."Last Time Modified");;

                  if UserSetupRegistrar.Get(ACAClearanceApprovalEntriesRegistrar."Clear By ID") then UserSetupRegistrar.CalcFields("User Signature");
                  if UserSetupRegistrar.UserName<>'' then RegistrarNames:=UserSetupRegistrar.UserName else RegistrarNames:=UserSetupRegistrar."User ID";
                    end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Faculty: Text[100];
        Prog: Record UnknownRecord61511;
        ProgStages: Record UnknownRecord61516;
        progName: Text[250];
        clearance_Levels: Record UnknownRecord77302;
        DeptName: Code[100];
        LastInDate: Date;
        DimVal: Record "Dimension Value";
        footer1: label 'All Students, upon completing a course, must ensure that they have been cleared from all sections above. It is the student''s';
        footer2: label 'responsibility to obtain clearance from all subject tutors and relevant officers. This Form when completed MUST be returned to the ';
        footer3: label 'Academic REGISTRAR''S Office.';
        hrEmp: Record UnknownRecord61188;
        ACAClearanceLevelCodes: Record UnknownRecord77302;
        Statuses: Code[20];
        ApprovalDateTime: DateTime;
        RegistraApprovalDateTime: DateTime;
        RegistrarStatuses: Code[20];
        UserSetup: Record "User Setup";
        ACAClearanceApprovalEntriesRegistrar: Record UnknownRecord77306;
        UserSetupRegistrar: Record "User Setup";
        RegistrarNames: Text[150];
}

