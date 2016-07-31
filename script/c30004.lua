 
--C帕秋莉
function c30004.initial_effect(c)
	--dark synchro summon
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c30004.syncon)
	e1:SetOperation(c30004.synop)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e1)
	--dice
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(30004,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c30004.target)
	e2:SetOperation(c30004.operation)
	c:RegisterEffect(e2)
	--cannot synchro
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--cannot xyz
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e6)
end
function c30004.matfilter1(c,syncard)
	return c:IsSetCard(0x6208) and c:IsType(TYPE_TUNER) and c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard)
end
function c30004.matfilter2(c,syncard)	
	return c:IsFaceup() and c:IsCanBeSynchroMaterial(syncard) and not c:IsType(TYPE_TUNER)
end
function c30004.synfilter1(c,lv,g1,g2)
	local tlv=c:GetLevel()	
	if c:GetFlagEffect(30000)==0 then	
	return g1:IsExists(c30004.synfilter3,1,nil,lv+tlv)
	else
	return g1:IsExists(c30004.synfilter3,1,nil,lv-tlv)
	end	
end
function c30004.synfilter3(c,lv)
	return c:GetLevel()==lv
end
function c30004.syncon(e,c,tuner)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<-1 then return false end
	local g1=Duel.GetMatchingGroup(c30004.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30004.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
	return g2:IsExists(c30004.synfilter1,1,nil,lv,g1,g2)
end
function c30004.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner)
	local g=Group.CreateGroup()
	local g1=Duel.GetMatchingGroup(c30004.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local g2=Duel.GetMatchingGroup(c30004.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local lv=c:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local m3=g2:FilterSelect(tp,c30004.synfilter1,1,1,nil,lv,g1,g2)
		local mt1=m3:GetFirst()
		g:AddCard(mt1)
		local lv1=mt1:GetLevel()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if mt1:GetFlagEffect(30000)==0 then	
		local t1=g1:FilterSelect(tp,c30004.synfilter3,1,1,nil,lv+lv1)
		g:Merge(t1)
		else 
		local t1=g1:FilterSelect(tp,c30004.synfilter3,1,1,nil,lv-lv1)
		g:Merge(t1)
		end			
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO+REASON_RULE)
end
function c30004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c30004.operation(e,tp,eg,ep,ev,re,r,rp)
	local dice=Duel.TossDice(tp,1)
	if dice==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g1,REASON_EFFECT)
	elseif dice==2 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	elseif dice==3 then
		local g2=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
	    Duel.Destroy(g2,REASON_EFFECT)
	elseif dice==4 then
		local g3=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	    Duel.Destroy(g3,REASON_EFFECT)
	elseif dice==5 then
		local g4=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	    Duel.Destroy(g4,REASON_EFFECT)
	else
		local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_FIELD)
	    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	    e1:SetCode(EFFECT_SKIP_TURN)
	    e1:SetTargetRange(0,1)
	    e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	    Duel.RegisterEffect(e1,tp)
	end
end
