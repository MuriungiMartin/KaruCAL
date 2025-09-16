#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51729 "Student ID"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student ID.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("Customer Type"=filter(Student));
            column(ReportForNavId_2; 2)
            {
            }
            column(studNo;Customer."No.")
            {
            }
            column(StudName;Customer.Name)
            {
            }
            column(cardExpiry;Customer."ID Card Expiry Year")
            {
            }
            column(Genders;Format(Customer.Gender))
            {
            }
            column(Cust_Picture;Customer.Picture)
            {
            }
            column(CompInfo_Picture;CompInfo.Picture)
            {
            }
            column(progdesc;Prog.Description)
            {
            }
            column(Signature;genset.Picture)
            {
            }
            column(Contacts1;CompInfo.Address+'-'+CompInfo."Post Code"+', '+CompInfo.City+'. Tel: '+CompInfo."Phone No.")
            {
            }
            column(RegDate;Customer."Date Registered")
            {
            }
            column(Barcode;Customer."Barcode Picture")
            {
            }

            trigger OnAfterGetRecord()
            begin

                //CardExpiry:=Cust."ID Card Expiry Year";
                 Customer.CalcFields(Customer."Barcode Picture");
                courseReg.Reset;
                courseReg.SetRange(courseReg."Student No.",Customer."No.");
                courseReg.SetFilter(courseReg.Programme,'<>%1','');
                if courseReg.Find('+') then begin
                  Prog.Reset;
                  Prog.SetRange(Prog.Code,courseReg.Programme);
                  if Prog.Find('-') then begin
                  end;
                end;

                genset.Reset;
                if genset.Find('-') then begin
                  genset.CalcFields(genset.Picture);
                  genset.CalcFields(genset."Bar Code");
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

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(CompInfo.Picture);
        CompInfo.CalcFields(Picture);
    end;

    var
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        CompInfo: Record "Company Information";
        LevelCaptionLbl: label 'Level';
        ProgrammeCaptionLbl: label 'Programme';
        NamesCaptionLbl: label 'Names';
        Signature_CaptionLbl: label 'Signature:';
        STUDENT_ID_CARDCaptionLbl: label 'STUDENT ID CARD';
        CardExpiry: Integer;
        No: Code[20];
        courseReg: Record UnknownRecord61532;
        genset: Record UnknownRecord61534;
}

