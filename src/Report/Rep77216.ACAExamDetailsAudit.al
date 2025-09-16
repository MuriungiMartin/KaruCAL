#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77216 "ACA-Exam Details Audit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Exam Details Audit.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(ExamsAudit;UnknownTable77216)
        {
            RequestFilterFields = Semester,Programme,Stage,Unit;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;ExamsAudit."Student No.")
            {
            }
            column(Prog;ExamsAudit.Programme)
            {
            }
            column(Stage;ExamsAudit.Stage)
            {
            }
            column(UnitCode;ExamsAudit.Unit)
            {
            }
            column(Semester;ExamsAudit.Semester)
            {
            }
            column(ExamType;ExamsAudit.ExamType)
            {
            }
            column(RegTranID;ExamsAudit."Reg. Transaction ID")
            {
            }
            column(EntryNo;ExamsAudit."Entry No")
            {
            }
            column(Cancelled;ExamsAudit.Cancelled)
            {
            }
            column(Scores;ExamsAudit.Score)
            {
            }
            column(Exam;ExamsAudit.Exam)
            {
            }
            column(Grade;ExamsAudit.Grade)
            {
            }
            column(AdminNo;ExamsAudit."Admission No")
            {
            }
            column(Lectnames;ExamsAudit."Lecturer Names")
            {
            }
            column(Userid;ExamsAudit.User_ID)
            {
            }
            column(LasteditedBy;ExamsAudit."Last Edited By")
            {
            }
            column(LastEditOn;ExamsAudit."Last Edited On")
            {
            }
            column(Submitted;ExamsAudit.Submitted)
            {
            }
            column(submittedOn;ExamsAudit."Submitted On")
            {
            }
            column(SubmittedBy;ExamsAudit."Submitted By")
            {
            }
            column(AcadYear;ExamsAudit."Academic Year")
            {
            }
            column(LastModBy;ExamsAudit."Last Modified by")
            {
            }
            column(LastModDate;ExamsAudit."Last Modified Date")
            {
            }
            column(LastmodTime;ExamsAudit."Last Modified Time")
            {
            }
            column(UnitName;ExamsAudit."Unit Name")
            {
            }
            column(CustName;cust.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Clear(cust);
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

    trigger OnInitReport()
    begin
        if ((UserId <>'KUCSERVER\PGITHINJI') and (UserId <>'KUCSERVER\MKUYU')) then Error('Error');
    end;

    var
        cust: Record Customer;
}

