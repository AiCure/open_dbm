import setuptools


with open('requirements.txt') as fp:
    install_requires = fp.read()

setuptools.setup(
    name="open_dbm",
    version="0.0.1",
    author="Vijay Yadav",
    author_email='vijay.yadav@aicure.com',
    description="openDBM",
    license='',
    packages=setuptools.find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=3.6',
    py_modules=["open_dbm"],
    #package_dir={'':'open_dbm'},     # Directory of the source code of the package
    install_requires = install_requires
)
