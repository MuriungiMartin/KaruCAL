#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51877 "Upload Student Photos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Upload Student Photos.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Stage,Semester,"Academic Year";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            dataitem(Customer;Customer)
            {
                DataItemLink = "No."=field("Student No.");
                column(ReportForNavId_1000000001; 1000000001)
                {
                }

                trigger OnAfterGetRecord()
                var
                    StudNo: Text;
                    InStream: InStream;
                    ServerFile: Text;
                    Oustream: OutStream;
                begin
                    Customer.CalcFields(Picture);
                    if Customer.Picture.Hasvalue then
                      CurrReport.Skip();

                    StudNo := ReplaceString(Customer."No.",'/','_');
                    //MESSAGE(StudNo);

                    fileePath := '\\172.16.0.110\BSRIS Photos\' + StudNo + '.jpg';

                    if not Exists(fileePath) then begin
                      CurrReport.Skip;
                    end;



                      TempFile.Open(fileePath);
                      TempFile.CreateInstream(InStream);
                      Customer.Picture.CreateOutstream(Oustream);
                      CopyStream(Oustream,InStream);
                      Customer.Picture.CreateInstream(InStream);

                      TempFile.Close;
                    Customer.Modify;
                end;

                trigger OnPreDataItem()
                var
                    FilePath: Text;
                begin
                end;
            }
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
        Bytes: dotnet Array;
        Convert: dotnet Array;
        Memorystream: dotnet Array;
        Base64Stream: dotnet Array;
        FileManagement: Codeunit "File Management";
        TempFile: File;
        fileePath: Text;
        TempBlob: Record TempBlob;

    local procedure ReplaceString(String: Text[250];FindWhat: Text[250];ReplaceWith: Text[250]) NewString: Text[250]
    begin
        while StrPos(String,FindWhat) > 0 do
          String := DelStr(String,StrPos(String,FindWhat)) + ReplaceWith + CopyStr(String,StrPos(String,FindWhat) + StrLen(FindWhat));
        NewString := String;
    end;
}

