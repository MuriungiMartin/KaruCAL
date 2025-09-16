#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66672 "Clear Graduated From Graduatio"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("In Graduation"=filter(true),Status=filter(Alumni|"Graduated no Certificates"|"Graduated with Certificate"|"Completed not graduated"));
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(GradRes;UnknownTable66633)
            {
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    GradRes.Delete;
                end;
            }
            dataitem(ClassUnits;UnknownTable66632)
            {
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000002; 1000000002)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClassUnits.Delete;
                end;
            }
            dataitem(ClassReg;UnknownTable66631)
            {
                DataItemLink = "Student Number"=field("No.");
                column(ReportForNavId_1000000003; 1000000003)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClassReg.Delete;
                end;
            }
            dataitem(ClassStuds;UnknownTable66630)
            {
                DataItemLink = "Student Number"=field("No.");
                column(ReportForNavId_1000000004; 1000000004)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClassStuds.Delete;
                end;
            }
            dataitem(ClassDet;UnknownTable66613)
            {
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000005; 1000000005)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClassDet.Delete;
                end;
            }
            dataitem(ClassPresidence;UnknownTable66600)
            {
                DataItemLink = "Student No."=field("No.");
                column(ReportForNavId_1000000007; 1000000007)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ClassPresidence.Delete;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Customer.Status:=Customer.Status::Alumni;
                Customer.Modify;
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
        dicks: Dialog;
}

