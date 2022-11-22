#include <algorithm>
#include <iostream>
#include <filesystem>
#include <fstream>

#include "zpipe.h"
#include <gtest/gtest.h>

TEST(zlib_minimal, full) {
    // Build file names, you can change the test_file_name to any existing path (without extension)
    // you like as long as you update the extension value 'test_file_extension'
    const char* test_file_name = "../CMakeLists";
    const char* test_file_extension = ".txt";
    std::string test_file_path = test_file_name + std::string(test_file_extension);
    std::string compressed_test_file = test_file_path + ".gz";


    FILE* to_compress = fopen(test_file_path.c_str(), "r");
    ASSERT_NE(to_compress, nullptr);

    FILE* compress_target = fopen(compressed_test_file.c_str(), "w");
    ASSERT_NE(compress_target, nullptr);

    // Compress file using zlib def function (for deflating)
    def(to_compress, compress_target, 9);

    // Close files to prevent issues with opening them again later
    fclose(to_compress);
    fclose(compress_target);

    ASSERT_TRUE(std::filesystem::exists(compressed_test_file));

    std::string decompressed_test_file = std::string(test_file_name) + "_decompressed" + test_file_extension;

    FILE* compressed_file = fopen(compressed_test_file.c_str(), "r");
    ASSERT_NE(compressed_file, nullptr);

    FILE* decompress_target = fopen(decompressed_test_file.c_str(), "w");
    ASSERT_NE(decompress_target, nullptr);

    // Decompress file using zlib inf function
    inf(compressed_file, decompress_target);

    // Close files to prevent issues with opening them again later
    fclose(compressed_file);
    fclose(decompress_target);

    ASSERT_TRUE(std::filesystem::exists(decompressed_test_file));

    // Compare file contents
    std::ifstream original(test_file_path, std::ifstream::in);

    ASSERT_TRUE(original.good());

    std::stringstream original_contents;
    original_contents << original.rdbuf();

    std::ifstream decompressed(decompressed_test_file, std::ifstream::in);

    ASSERT_TRUE(decompressed.good());

    std::stringstream decompressed_contents;
    decompressed_contents << decompressed.rdbuf();

    ASSERT_EQ(original_contents.str(), decompressed_contents.str());
}

