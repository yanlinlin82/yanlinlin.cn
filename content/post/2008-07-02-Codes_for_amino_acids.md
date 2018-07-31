---
title: Codes for amino acids
slug: codes-for-amino-acids
date: 2008-07-02T12:22:00+08:00
place: 北京
categories: [ 旧文, 科学 ]
tags: [ 生物信息学, 氨基酸 ]
host-at: LiveSpace
---
It is known that amino acids or nucleotide acids can be represented as codes of either triple letters or single letter. When I was learning pairwise alignment algorithm a few days ago, I found that there is a letter ‘J’, a single letter for amino acid that I had never seen before, in NCBI’s scoring matrix. I posted the question in the newsgroup and got the answer in the next day. Thank Hamish McWilliam of EBI, who mailed me with a very detail explanation. Following are the codes for amino acids (from <http://www.ebi.ac.uk/RESID/faq.html#q01>).

<table>
<tr style="font-weight: bold;" align="center">
<th colspan="6">Standard Encoded Amino Acids</th>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">A</td>
<td>Ala</td>
<td>alanine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">M</td>
<td>Met</td>
<td>methionine</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">C</td>
<td>Cys</td>
<td>cysteine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">N</td>
<td>Asn</td>
<td>asparagine (&#8220;asparagi<b>N</b>e&#8221;, &#8220;aspartic-<b>N</b>H2&#8243;)</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">D</td>
<td>Asp</td>
<td>aspartic acid (&#8220;aspar<b>D</b>ic acid&#8221;)</td>
<td style="text-align: center; width: 25px; font-weight: bold;">P</td>
<td>Pro</td>
<td>proline</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">E</td>
<td>Glu</td>
<td>glutamic acid (&#8220;glu<b>E</b>tamic acid&#8221;)</td>
<td style="text-align: center; width: 25px; font-weight: bold;">Q</td>
<td>Gln</td>
<td>glutamine (&#8220;<b>Q</b>utamine&#8221;)</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">F</td>
<td>Phe</td>
<td>phenylalanine (&#8220;<b>F</b>enylalanine&#8221;)</td>
<td style="text-align: center; width: 25px; font-weight: bold;">R</td>
<td>Arg</td>
<td>arginine (&#8220;a<b>R</b>ginine&#8221;)</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">G</td>
<td>Gly</td>
<td>glycine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">S</td>
<td>Ser</td>
<td>serine</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">H</td>
<td>His</td>
<td>histidine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">T</td>
<td>Thr</td>
<td>threonine</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">I</td>
<td>Ile</td>
<td>isoleucine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">V</td>
<td>Val</td>
<td>valine</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">K</td>
<td>Lys</td>
<td>lysine (&#8220;<b>K</b>&#8221; next to &#8220;L&#8221;)</td>
<td style="text-align: center; width: 25px; font-weight: bold;">W</td>
<td>Trp</td>
<td>tryptophan (&#8220;t<b>W</b>iptophan&#8221;, or double-ring)</td>
</tr>
<tr>
<td style="text-align: center; width: 25px; font-weight: bold;">L</td>
<td>Leu</td>
<td>leucine</td>
<td style="text-align: center; width: 25px; font-weight: bold;">Y</td>
<td>Tyr</td>
<td>tyrosine (&#8220;t<b>Y</b>rosine&#8221;)</td>
</tr>
<tr style="font-weight: bold;" align="center">
<th colspan="6">Amino Acid Ambiguities</th>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">B</td>
<td>Asx</td>
<td colspan="4">aspartic acid or asparagine (&#8220;<b>B</b>&#8221; near &#8220;D&#8221;, uncertain result of hydrolysis)</td>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">J</td>
<td>Xle</td>
<td colspan="4">leucine or isoleucine (&#8220;<b>J</b>&#8221; between &#8220;I&#8221; and &#8220;L&#8221;, uncertain result of mass-spec)</td>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">X</td>
<td>Xaa</td>
<td colspan="4">unknown or unspecified amino acid (&#8220;Unk&#8221; is sometimes used as an abbreviation)</td>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">Z</td>
<td>Glx</td>
<td colspan="4">glutamic acid or glutamine (&#8220;<b>Z</b>&#8221; near &#8220;X&#8221;, uncertain result of hydrolysis)</td>
</tr>
<tr style="font-weight: bold;" align="center">
<th colspan="6">Special Encoded Amino Acids</th>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">U</td>
<td>Sec</td>
<td colspan="4">selenocysteine (the UniProt Knowledgebase uses &#8220;C&#8221; and a feature rather than &#8220;U&#8221;)</td>
</tr>
<tr>
<td style="text-align: center; font-weight: bold;">O</td>
<td>Pyl</td>
<td colspan="4">pyrrolysine (&#8220;pyrr<b>O</b>lysine&#8221;, the UniProt Knowledgebase uses &#8220;K&#8221; and a feature rather than &#8220;O&#8221;)</td>
</tr>
</table>
