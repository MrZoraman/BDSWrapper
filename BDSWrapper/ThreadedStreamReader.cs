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

using System.Threading.Tasks;

namespace BDSWrapper
{
    using System.Collections.Concurrent;
    using System.IO;
    using System.Threading;

    public class ThreadedStreamReader
    {
        private readonly Thread _thread;
        private readonly TextReader _reader;
        private readonly BlockingCollection<string> _buffer = new ();

        public ThreadedStreamReader(TextReader reader, string name)
        {
            _thread = new Thread(Run)
            {
                IsBackground = true,
                Name = name,
            };

            _reader = reader;
        }

        public void Start()
        {
            if (!_thread.IsAlive)
            {
                _thread.Start();
            }
        }

        private void Run()
        {
            while (true)
            {
                var input = _reader.ReadLine();
                if (input == null)
                {
                    continue;
                }

                _buffer.Add(input);
            }
        }

        public Task<string?> ReadLineAsync(CancellationToken token)
        {
            return _buffer.TakeAsync(token);
        }
    }
}
