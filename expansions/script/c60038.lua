--白发学园教师 库蕾芭
function c60038.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60038,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c60038.spcost)
	e1:SetTarget(c60038.sptg)
	e1:SetOperation(c60038.spop)
	c:RegisterEffect(e1)
end
function c60038.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c60038.filter(c,e,tp)
	return c:IsSetCard(0x191) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c60038.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c60038.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c60038.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60038.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local lve=e:GetHandler():GetLevel()
		local lvg=g:GetFirst():GetLevel()
		local lv=math.abs(lve-lvg)*2
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,lv,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
