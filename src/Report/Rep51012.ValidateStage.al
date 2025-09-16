#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51012 "Validate Stage"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61758;UnknownTable61758)
        {
            DataItemTableView = where("Clearance Level Code"=filter(HOD));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                clearDept.Reset;
                clearDept.SetRange(clearDept."Clearance Level Code","ACA-Clearance Approval Entries"."Clearance Level Code");
                clearDept.SetRange(clearDept.Department,"ACA-Clearance Approval Entries".Department); //
                if clearDept.Find('-') then begin //Clearance Level Code,Department,Student ID,Clear By ID
                  repeat
                    begin
                      if not (ClearLedgers.Get("ACA-Clearance Approval Entries"."Clearance Level Code","ACA-Clearance Approval Entries".Department,
                      "ACA-Clearance Approval Entries"."Student ID",clearDept."Clear By Id")) then begin
                        ClearLedgers.Init;
                         ClearLedgers."Clearance Level Code":="ACA-Clearance Approval Entries"."Clearance Level Code";
                         ClearLedgers.Department:="ACA-Clearance Approval Entries".Department;
                         ClearLedgers."Student ID":="ACA-Clearance Approval Entries"."Student ID";
                         ClearLedgers."Clear By ID":=clearDept."Clear By Id";
                         ClearLedgers."Initiated By":="ACA-Clearance Approval Entries"."Initiated By";
                         ClearLedgers."Initiated Date":="ACA-Clearance Approval Entries"."Initiated Date";
                         ClearLedgers."Initiated Time":="ACA-Clearance Approval Entries"."Initiated Time";
                         ClearLedgers."Last Date Modified":="ACA-Clearance Approval Entries"."Last Date Modified";
                         ClearLedgers."Last Time Modified":=  "ACA-Clearance Approval Entries"."Last Time Modified";
                         ClearLedgers."Student Intake":= "ACA-Clearance Approval Entries"."Student Intake";
                         ClearLedgers."Priority Level":=  "ACA-Clearance Approval Entries"."Priority Level";
                         ClearLedgers."Academic Year":= "ACA-Clearance Approval Entries"."Academic Year";
                         ClearLedgers.Semester:="ACA-Clearance Approval Entries".Semester;
                         ClearLedgers.Status:="ACA-Clearance Approval Entries".Status;
                        ClearLedgers.Insert();
                      end;
                    end;
                  until clearDept.Next=0;
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
        ClearLedgers: Record UnknownRecord61758;
        clearTemps: Record UnknownRecord61755;
        clearDept: Record UnknownRecord61756;
}

