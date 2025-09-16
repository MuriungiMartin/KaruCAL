#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2001 "Azure ML Connector"
{

    trigger OnRun()
    begin
    end;

    var
        [WithEvents]
        AzureMLRequest: dotnet AzureMLRequest;
        [WithEvents]
        AzureMLParametersBuilder: dotnet AzureMLParametersBuilder;
        [WithEvents]
        AzureMLInputBuilder: dotnet AzureMLInputBuilder;
        HttpMessageHandler: dotnet HttpMessageHandler;
        ProcessingTime: Decimal;
        OutputNameTxt: label 'Output1', Locked=true;
        InputNameTxt: label 'input1', Locked=true;
        ParametersNameTxt: label 'Parameters', Locked=true;
        InputName: Text;
        OutputName: Text;
        ParametersName: Text;


    procedure Initialize(ApiKey: Text;ApiUri: Text;TimeOutSeconds: Integer)
    begin
        AzureMLRequest := AzureMLRequest.AzureMLRequest(ApiKey,ApiUri,TimeOutSeconds);
        // To set HttpMessageHandler first call SetMessageHandler
        AzureMLRequest.SetHttpMessageHandler(HttpMessageHandler);

        AzureMLInputBuilder := AzureMLInputBuilder.AzureMLInputBuilder;

        AzureMLParametersBuilder := AzureMLParametersBuilder.AzureMLParametersBuilder;

        OutputName := OutputNameTxt;
        InputName := InputNameTxt;
        ParametersName := ParametersNameTxt;

        AzureMLRequest.SetInput(InputName,AzureMLInputBuilder);
        AzureMLRequest.SetParameter(ParametersName,AzureMLParametersBuilder);
    end;


    procedure IsInitialized(): Boolean
    begin
        exit(not IsNull(AzureMLRequest) and not IsNull(AzureMLInputBuilder) and not IsNull(AzureMLParametersBuilder));
    end;


    procedure SendToAzureML(): Boolean
    var
        AzureMachineLearningUsage: Record "Azure Machine Learning Usage";
    begin
        if not SendRequestToAzureML then
          exit(false);

        // Convert to seconds
        ProcessingTime := ProcessingTime / 1000;
        AzureMachineLearningUsage.IncrementTotalProcessingTime(ProcessingTime);
        exit(true);
    end;

    [TryFunction]

    procedure SendRequestToAzureML()
    begin
        AzureMLRequest.SetHttpMessageHandler(HttpMessageHandler);
        ProcessingTime := AzureMLRequest.InvokeRequestResponseService;
    end;


    procedure SetMessageHandler(MessageHandler: dotnet HttpMessageHandler)
    begin
        HttpMessageHandler := MessageHandler;
    end;

    [TryFunction]

    procedure SetInputName(Name: Text)
    begin
        InputName := Name;
        AzureMLRequest.SetInput(InputName,AzureMLInputBuilder);
    end;

    [TryFunction]

    procedure AddInputColumnName(ColumnName: Text)
    begin
        AzureMLInputBuilder.AddColumnName(ColumnName);
    end;

    [TryFunction]

    procedure AddInputRow()
    begin
        AzureMLInputBuilder.AddRow;
    end;

    [TryFunction]

    procedure AddInputValue(Value: Text)
    begin
        AzureMLInputBuilder.AddValue(Value);
    end;

    [TryFunction]

    procedure AddParameter(Name: Text;Value: Text)
    begin
        AzureMLParametersBuilder.AddParameter(Name,Value);
    end;

    [TryFunction]

    procedure SetParameterName(Name: Text)
    begin
        ParametersName := Name;
        AzureMLRequest.SetParameter(ParametersName,AzureMLParametersBuilder);
    end;

    [TryFunction]

    procedure SetOutputName(Name: Text)
    begin
        OutputName := Name;
    end;

    [TryFunction]

    procedure GetOutput(LineNo: Integer;ColumnNo: Integer;var OutputValue: Text)
    begin
        OutputValue := AzureMLRequest.GetOutputValue(OutputName,LineNo - 1,ColumnNo - 1);
    end;

    [TryFunction]

    procedure GetOutputLength(var Length: Integer)
    begin
        Length := AzureMLRequest.GetOutputLength(OutputName);
    end;

    [TryFunction]

    procedure GetInput(LineNo: Integer;ColumnNo: Integer;var InputValue: Text)
    begin
        InputValue := AzureMLInputBuilder.GetValue(LineNo - 1,ColumnNo - 1);
    end;

    [TryFunction]

    procedure GetInputLength(var Length: Integer)
    begin
        Length := AzureMLInputBuilder.GetLength;
    end;

    [TryFunction]

    procedure GetParameter(Name: Text;var ParameterValue: Text)
    begin
        ParameterValue := AzureMLParametersBuilder.GetParameter(Name);
    end;
}

