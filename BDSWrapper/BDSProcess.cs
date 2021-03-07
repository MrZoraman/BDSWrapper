// Copyright (c) 2021 MrZoraman
//
// This software is provided 'as-is', without any express or implied
// warranty. In no event will the authors be held liable for any damages
// arising from the use of this software.
//
// Permission is granted to anyone to use this software for any purpose,
// including commercial applications, and to alter it and redistribute it
// freely, subject to the following restrictions:
//
// 1. The origin of this software must not be misrepresented; you must not
//    claim that you wrote the original software. If you use this software
//    in a product, an acknowledgment in the product documentation would be
//    appreciated but is not required.
// 2. Altered source versions must be plainly marked as such, and must not be
//    misrepresented as being the original software.
// 3. This notice may not be removed or altered from any source distribution.

using System.Text;
using Serilog;

namespace BDSWrapper
{
    using System;
    using System.Collections.Concurrent;
    using System.Diagnostics;
    using System.Threading;
    using System.Threading.Tasks;

    public sealed class BDSProcess : IDisposable
    {
        private readonly Process _process;
        private readonly CancellationTokenSource _cancelSource = new ();
        private readonly ThreadedStreamReader _consoleInputReader;
        private ThreadedStreamReader? _processOutputReader = null;

        public BDSProcess(ThreadedStreamReader consoleInputReader)
        {
            _process = new Process
            {
                StartInfo =
                {
                    FileName = "bds/bedrock_server",
                    RedirectStandardOutput = true,
                    RedirectStandardInput = true,
                },
            };

            _process.StartInfo.EnvironmentVariables["LD_LIBRARY_PATH"] = ".";

            _process.Exited += (_, _) => _cancelSource.Cancel();
            _consoleInputReader = consoleInputReader;
        }

        /// <inheritdoc />
        public void Dispose()
        {
            _cancelSource.Dispose();
            _process.Dispose();
        }

        public async Task RunAsync()
        {
            _process.Start();

            _processOutputReader =
                new ThreadedStreamReader(_process.StandardOutput, "Process output reader");
            _processOutputReader.Start();

            await Task.WhenAll(
                _process.WaitForExitAsync(),
                SendInputToProcessAsync(),
                ReadOutputAsync());

            Log.Debug("RunAsync has finished. Has exited: {status}", _process.HasExited);
        }

        public void RequestStop()
        {
            _process.StandardInput.WriteLine("Stop");
        }

        private async Task ReadOutputAsync()
        {
            if (_processOutputReader == null)
            {
                throw new InvalidOperationException("Process output reader has not started yet!");
            }

            var token = _cancelSource.Token;
            while (!token.IsCancellationRequested)
            {
                var output = await _processOutputReader.ReadLineAsync(token);
                if (output != null)
                {
                    Log.Information(output);
                }
            }
        }

        private async Task SendInputToProcessAsync()
        {
            var token = _cancelSource.Token;

            while (!token.IsCancellationRequested)
            {
                var message = await _consoleInputReader.ReadLineAsync(token);
                if (message != null)
                {
                    await _process.StandardInput.WriteLineAsync(new StringBuilder(message), token);
                }
            }
        }
    }
}
