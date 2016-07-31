 
--告春精✿莉莉布莱克
function c20166.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20166,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c20166.hspcost)
	e1:SetTarget(c20166.hsptg)
	e1:SetOperation(c20166.hspop)
	c:RegisterEffect(e1)
end
function c20166.cfilter(c)
	return (c:IsCode(20013) or c:IsCode(20163) or c:IsCode(5519829)) and c:IsFaceup() and c:IsType(TYPE_TUNER)
end
function c20166.filter(c)
	return (c:IsCode(20013) or c:IsSetCard(0x123)) and c:IsFaceup()
end
function c20166.hspcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,20166)==0 and Duel.CheckLPCost(tp,600)
		and Duel.IsExistingMatchingCard(c20166.cfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.PayLPCost(tp,600)
	Duel.RegisterFlagEffect(tp,20166,RESET_PHASE+PHASE_END,0,1)
end
function c20166.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c20166.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetMatchingGroup(c20166.filter,tp,LOCATION_MZONE,0,nil)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0xff0000)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end
