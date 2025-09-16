#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51382 "HMS Injection Register Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HMS Injection Register Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61409;UnknownTable61409)
        {
            column(ReportForNavId_3772; 3772)
            {
            }
            column(Injection_18_;Injection[18])
            {
            }
            column(Injection_15_;Injection[15])
            {
            }
            column(Injection_16_;Injection[16])
            {
            }
            column(Injection_17_;Injection[17])
            {
            }
            column(Injection_14_;Injection[14])
            {
            }
            column(Injection_13_;Injection[13])
            {
            }
            column(Injection_12_;Injection[12])
            {
            }
            column(Injection_11_;Injection[11])
            {
            }
            column(Injection_10_;Injection[10])
            {
            }
            column(Injection_9_;Injection[9])
            {
            }
            column(Injection_8_;Injection[8])
            {
            }
            column(Injection_7_;Injection[7])
            {
            }
            column(Injection_6_;Injection[6])
            {
            }
            column(Injection_5_;Injection[5])
            {
            }
            column(Injection_4_;Injection[4])
            {
            }
            column(Injection_3_;Injection[3])
            {
            }
            column(Injection_2_;Injection[2])
            {
            }
            column(Injection_1_;Injection[1])
            {
            }
            column(UPPERCASE_COMPANYNAME_;UpperCase(COMPANYNAME))
            {
            }
            column(Drug_1_;Drug[1])
            {
            }
            column(PFNo_1_;PFNo[1])
            {
            }
            column(PatientName_1_;PatientName[1])
            {
            }
            column(Dose_1_;Dose[1])
            {
            }
            column(PFNo_2_;PFNo[2])
            {
            }
            column(PatientName_2_;PatientName[2])
            {
            }
            column(Drug_2_;Drug[2])
            {
            }
            column(Dose_2_;Dose[2])
            {
            }
            column(SIGNATURECaption;SIGNATURECaptionLbl)
            {
            }
            column(DOSECaption;DOSECaptionLbl)
            {
            }
            column(DRUGCaption;DRUGCaptionLbl)
            {
            }
            column(NAMECaption;NAMECaptionLbl)
            {
            }
            column(OP_IP_NO_Caption;OP_IP_NO_CaptionLbl)
            {
            }
            column(SIGNATURECaption_Control1102760076;SIGNATURECaption_Control1102760076Lbl)
            {
            }
            column(DOSECaption_Control1102760093;DOSECaption_Control1102760093Lbl)
            {
            }
            column(DRUGCaption_Control1102760100;DRUGCaption_Control1102760100Lbl)
            {
            }
            column(NAMECaption_Control1102760112;NAMECaption_Control1102760112Lbl)
            {
            }
            column(DATE__________________________________________________Caption;DATE__________________________________________________CaptionLbl)
            {
            }
            column(OP_IP_NO_Caption_Control1102760119;OP_IP_NO_Caption_Control1102760119Lbl)
            {
            }
            column(University_HEALTH_SERVICESCaption;University_HEALTH_SERVICESCaptionLbl)
            {
            }
            column(INJECTION_REGISTERCaption;INJECTION_REGISTERCaptionLbl)
            {
            }
            column(HMS_Treatment_Form_Injection_Treatment_No_;"Treatment No.")
            {
            }
            column(HMS_Treatment_Form_Injection_Injection_No_;"Injection No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if FirstRecordPrinted then begin Next(-1) end;
                for IntD:=1 to 2 do
                    begin
                      Treatment.Reset;
                      Treatment.Get("Treatment No.");
                      Patient.Reset;
                      Patient.Get(Treatment."Patient No.");
                      PatientName[IntD]:=Patient.Surname + ' ' + Patient."Middle Name" +' ' + Patient."Last Name";
                      if Patient."Patient Type"=Patient."patient type"::Others then
                        begin
                          PFNo[IntD]:=Patient."Student No.";
                        end
                      else if Patient."Patient Type"=Patient."patient type"::" " then
                        begin
                          PFNo[IntD]:=Patient."Patient No.";
                        end
                      else
                        begin
                          PFNo[IntD]:=Patient."Employee No.";
                        end;
                        Drug[IntD]:="Injection No.";
                        Dose[IntD]:=Format("Injection Quantity") + ' ' + "Injection Unit of Measure";
                        Next();
                    end;
                FirstRecordPrinted:=true;
            end;

            trigger OnPreDataItem()
            begin
                //LastFieldNo := FIELDNO(Code);
                IntC:=1;
                InjectionRec.Reset;
                if InjectionRec.Find('-') then
                  begin
                    repeat
                      begin
                        Injection[IntC]:=InjectionRec.Description;
                        IntC:=IntC +1;
                        Next(1);
                      end;
                    until InjectionRec.Next=0;
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
        IntD:=1;
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Injection: array [18] of Text[100];
        IntC: Integer;
        InjectionRec: Record UnknownRecord61398;
        IntD: Integer;
        TreatmentInjection: Record UnknownRecord61409;
        PFNo: array [2] of Code[20];
        PatientName: array [2] of Text[200];
        Drug: array [2] of Code[10];
        Dose: array [2] of Code[30];
        Patient: Record UnknownRecord61402;
        Treatment: Record UnknownRecord61407;
        FirstRecordPrinted: Boolean;
        SIGNATURECaptionLbl: label 'SIGNATURE';
        DOSECaptionLbl: label 'DOSE';
        DRUGCaptionLbl: label 'DRUG';
        NAMECaptionLbl: label 'NAME';
        OP_IP_NO_CaptionLbl: label 'OP/IP NO.';
        SIGNATURECaption_Control1102760076Lbl: label 'SIGNATURE';
        DOSECaption_Control1102760093Lbl: label 'DOSE';
        DRUGCaption_Control1102760100Lbl: label 'DRUG';
        NAMECaption_Control1102760112Lbl: label 'NAME';
        DATE__________________________________________________CaptionLbl: label 'DATE _________________________________________________';
        OP_IP_NO_Caption_Control1102760119Lbl: label 'OP/IP NO.';
        University_HEALTH_SERVICESCaptionLbl: label 'University HEALTH SERVICES';
        INJECTION_REGISTERCaptionLbl: label 'INJECTION REGISTER';
}

